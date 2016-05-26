# == Schema Information
#
# Table name: media
#
#  id                       :integer          not null, primary key
#  photographer_id          :integer
#  quality_type_id          :integer
#  created_on               :datetime
#  updated_on               :datetime
#  recording_note           :text
#  private_note             :text
#  type                     :string(20)       not null
#  attachment_id            :integer
#  taken_on                 :datetime
#  recording_orientation_id :integer
#  capture_device_model_id  :integer
#  partial_taken_on         :string(255)
#  application_filter_id    :integer          not null
#  resource_type_id         :integer          not null
#  rotation                 :integer
#

require 'fileutils'
class Medium < ActiveRecord::Base
  include Util, FileUtils, MediaProcessor::MediumExtension, FilenameUtils
  ROWS = 5
  COLS = 4
  PREVIEW_ROWS = 2
  FULL_ROWS = 4
  FULL_COLS = 8
  COMMON_SIZES = {:compact => {:quality => 70, :geometry => 'c95x95', :density => 260}, :thumb => {:quality => 70, :geometry => 'c120x120', :density => 260}, :search => {:quality => 70, :geometry => '150x150', :density => 260}, :essay => {:quality => 80, :geometry => '280x280>', :density => 260}, :normal => {:quality => 80, :geometry => '500x500>', :density => 260}, :large => {:quality => 80, :geometry => '800x700>', :density => 260}, :huge => {:quality => 90, :geometry => '2000x2000>'} }
  # The keys of TYPES should correspond to class names
  TYPES = {
    :picture => {:singular => 'Picture', :plural => 'Pictures'},
    #:audio => {:singular => 'Audio', :plural => 'Audio'},
    :video => {:singular => 'Video', :plural => 'Videos'},
    #:immersive => {:singular => 'Immersive', :plural => 'Immersive'},
    :document => {:singular => 'Document', :plural => 'Documents'}
    #:biblio => {:singular => 'Biblio', :plural => 'Biblio'}
  }
  
  before_create  { |record| record.application_filter = ApplicationFilter.default_filter }
  after_create   { |record| record.rename } # TODO: handle if it couldn't be saved
  before_destroy do |record|
    captions_array = record.captions
    for caption in captions_array
      caption.destroy
    end
    record.captions.clear
    descriptions_array = record.descriptions
    for description in descriptions_array
      description.destroy
    end
    record.descriptions.clear
    delete_setting = ApplicationSetting.find_by(title: 'delete_from_cold_storage')
    delete_from_coldstorage if delete_setting.nil? || delete_setting.value==1
  end
  
  default_scope { where(:application_filter_id => ApplicationFilter.application_filter.id) } if !ApplicationFilter.application_filter.nil?
  
  belongs_to :capture_device_model  
  belongs_to :application_filter
  belongs_to :photographer, :class_name => 'AuthenticatedSystem::Person', :foreign_key => 'photographer_id'
  belongs_to :quality_type
  belongs_to :recording_orientation
  # belongs_to :resource_type, :class_name => 'Topic'
  
  has_and_belongs_to_many :captions
  has_and_belongs_to_many :descriptions
  has_and_belongs_to_many :sources
  
  has_one :workflow, :dependent => :destroy
  has_one  :media_recording_administrative_location, :dependent => :destroy
  has_one :media_publisher, :dependent => :destroy
  
  has_many :media_source_associations, :dependent => :destroy
  has_many :sources, :through => :media_source_associations
  has_many :media_content_administrative_locations, -> { order 'type DESC' }, dependent: :destroy
  has_many :locations, :dependent => :destroy
  has_many :media_category_associations, :dependent => :destroy
  has_many :media_keyword_associations, :dependent => :destroy
  has_many :cumulative_media_location_associations
  has_many :copyrights, :dependent => :destroy
  has_many :affiliations, :dependent => :destroy
  has_many :keywords, -> { order 'title' }, through: :media_keyword_associations
  has_many :cumulative_media_category_associations, :dependent => :destroy
  has_many :titles, :dependent => :destroy
  
  scope :no_caption, -> { where('media.id NOT IN (SELECT medium_id FROM captions_media)') }
  scope :no_description, -> { where('media.id NOT IN (SELECT medium_id FROM descriptions_media)') }
  scope :no_place, -> { where('media.id NOT IN (SELECT medium_id FROM locations)') } # Medium.includes(:locations).where(:locations => {:id => nil})
  scope :no_subject, -> { where('media.id NOT IN (SELECT medium_id FROM media_category_associations)') }

  def media_collection_associations
    self.media_category_associations.where(:root_id => Collection.root_id)
  end
  
  def media_subject_associations
    self.media_category_associations.where(:root_id => Subject.root_id)
  end
    
  def media_ethnicity_associations
    self.media_category_associations.where(:root_id => Ethnicity.root_id)
  end
  
  def collections
    self.media_collection_associations.collect(&:category).select{|c| c}
  end

  def subjects
    self.media_subject_associations.collect(&:category).select{|c| c}
  end

  def ethnicities
    self.media_ethnicity_associations.collect(&:category).select{|c| c}
  end
  
  def topics(options = {})
    #cumulative = options[:cumulative] || false
    #if cumulative
    #  return self.cumulative_media_category_associations.collect(&:category).select{|c| c}
    #else
      self.media_category_associations.collect(&:category).select{|c| c}
    #end
  end
  
  def resource_type
    Topic.find(self.resource_type_id)
  end
  
  def category_count(options = {})
    # association = options[:cumulative] || false ? CumulativeMediaCategoryAssociation : MediaCategoryAssociation
    # association.count(:conditions => {:medium_id => self.id})
    MediaCategoryAssociation.where(:medium_id => self.id).count
  end
  
  def features
    self.locations.collect(&:feature).select{|f| f}
  end
  
  def feature_count
    CumulativeMediaLocationAssociation.where(:medium_id => self.id).count
  end
  
  def topical_map_url
    SubjectsIntegration::SubjectsResource.get_url + medium_path
  end
  alias :kmaps_url :topical_map_url
  
  def places_url
    PlacesIntegration::PlacesResource.get_url + medium_path
  end
  
  def thumbnail_image
    att = attachment
    return nil if att.nil?
    att.children.find_by(thumbnail: 'compact')
  end
  
  def screen_size_image
    att = attachment
    return nil if att.nil?
    #img = att.children.find_by(thumbnail: 'large')
    #return img if !img.nil?
    img = att.children.find_by(thumbnail: 'normal')
    return img if !img.nil?
    img = att.children.find_by(thumbnail: 'essay')
    return img
  end
  
  def large_image
    att = attachment
    return nil if att.nil?
    att.children.find_by(thumbnail: 'large')
  end

  #not meant to be called in itself but within the page_media of administrative_units, subjects, collections, and ethnicities
  def self.paged_media(descendant_ids, limit, offset = nil, type = nil)
    conditions_string = String.new
    conditions_array = Array.new
    if !type.nil?
      conditions_string << 'AND media.type = ?'
      conditions_array << type
    end
    if offset.nil?
      conditions_string << ' ORDER BY created_on DESC LIMIT ?'
      conditions_array << limit
    else
      conditions_string << ' LIMIT ?, ?'
      conditions_array << offset
      conditions_array << limit
    end
    [conditions_string] + descendant_ids + conditions_array
  end
  
  #not meant to be called in itself but within the media_count of administrative_units, subjects, collections, and ethnicities
  def self.media_count(descendant_ids, type = nil)
    conditions_string = String.new
    conditions_array = Array.new
    if !type.nil?
      conditions_string = 'AND media.type = ?'
      conditions_array << type
    end
    [conditions_string] + descendant_ids + conditions_array
  end
  
  def self.media_search(media_search, type)
    conditions_string = 'media.id = ?'
    conditions_array = [media_search.title]
    ids = []
    if media_search.title.size > 3
      ids += Workflow.where([Util.search_condition_string(media_search.type, 'original_medium_id', true), media_search.title]).select('DISTINCT(medium_id)').collect(&:medium_id)
    else
      ids += Workflow.where([Util.search_condition_string(media_search.type, 'original_medium_id', false), "%#{media_search.title}%"]).select('DISTINCT(medium_id)').collect(&:medium_id)
    end
    ids += Workflow.where(['workflows.original_filename LIKE ?', "%#{media_search.title}%"]).select('DISTINCT(medium_id)').collect(&:medium_id)
    if type=='OnlineResource'
      ids += WebAddress.where(['web_addresses.url LIKE ?', "%#{media_search.title}%"]).select('DISTINCT(online_resource_id)').collect(&:online_resource_id)
    end
    # for now asumming that its English; change later TODO
    ids += Medium.joins(:captions).where(Util.search_condition_string(media_search.type, 'captions.title', true), media_search.title).select('DISTINCT(media.id)').collect(&:id)
    ids += Medium.joins(:descriptions).where(Util.search_condition_string(media_search.type, 'descriptions.title', true), media_search.title).select('DISTINCT(media.id)').collect(&:id)
    ids += Medium.joins(:titles).where(Util.search_condition_string(media_search.type, 'titles.title', true), media_search.title).select('DISTINCT(media.id)').collect(&:id)
    ids += Medium.joins(:titles => :translated_titles).where(Util.search_condition_string(media_search.type, 'translated_titles.title', true), media_search.title).select('DISTINCT(media.id)').collect(&:id)
    media = Medium.where(:id => ids.uniq)
    media = media.where(:type => type) if !type.nil?
    media
  end
  
  def self.media_count_for_type(type)
    Medium.where(:type => type).count
  end
  
  def self.range(id_start, id_end)
    if id_end.nil?
      if id_start.nil?
        media = self.all
      else
        media = self.where(['id >= ?', id_start])
      end
    else
      if id_start.nil?
        media = self.where(['id <= ?', id_end])
      else
        media = self.where(['id >= ? AND id <= ?', id_start, id_end])
      end
    end   
  end
  
  
  def id_name
    actual_media = attachment
    if actual_media.nil?
      return nil
    else
      "#{id}#{extension(actual_media.filename)}"
    end
  end
  
  def partitioned_id_name
    actual_media = attachment
    if actual_media.nil?
      return nil
    else
      partitioned_path = ('%08d' % id).scan(/..../)
      partitioned_path[1] << extension(actual_media.filename)
      return File.join(partitioned_path)
    end
  end

  def cold_storage
    if @cold_storage.nil?
      # Check from cold-storage
      cold_storage_folder = ApplicationSetting.cold_storage_folder
      if !cold_storage_folder.nil?
        @cold_storage = File.join(cold_storage_folder, self.class.public_folder, self.partitioned_id_name)
      else
        @cold_storage = ''
      end
    end
    return @cold_storage.blank? ? nil : @cold_storage
  end
  
  def cold_storage_if_exists
    # Check from cold-storage
    cold_storage_file = self.cold_storage
    return !cold_storage_file.nil? && File.exist?(cold_storage_file) ? cold_storage_file : nil
  end
  
  def self.human_name(*args)
    self.model_name.human(*args)
  end
  
  def ingest_taken_on(params)
    if self.taken_on.nil? || self.taken_on.year < 0
      year_str = params['taken_on(1i)']
      year = year_str.to_i
      year_str = "#{year.abs} BCE" if !year_str.blank? && year < 0
      a = [params['taken_on(2i)'], params['taken_on(3i)'], year_str].reject(&:blank?)
      self.partial_taken_on = a.join('/') if !a.empty?
    end
  end
  
  private
      
  def delete_from_coldstorage
    media_full_path = cold_storage_if_exists
    return if media_full_path.nil?
    begin
      rm_f(media_full_path)
    rescue Exception => exc
    end
  end
  
  private
  
  def medium_path
    ['media_objects', self.id].join('/')
  end
end
