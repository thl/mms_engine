require 'fileutils'
class Medium < ActiveRecord::Base
  ROWS = 5
  COLS = 4
  PREVIEW_ROWS = 2
  FULL_ROWS = 4
  FULL_COLS = 8
  COMMON_SIZES = {:compact => '70:95x95#', :thumb => '70:120x120#', :search => '70:150x150', :essay => '80:280x280>', :normal => '80:500x500>', :large => '80:800x700>', :huge => '90:2000x2000>'}
  # The keys of TYPES should correspond to class names
  TYPES = {
    :picture => {:singular => 'Picture', :plural => 'Pictures'},
    #:audio => {:singular => 'Audio', :plural => 'Audio'},
    :video => {:singular => 'Video', :plural => 'Videos'},
    #:immersive => {:singular => 'Immersive', :plural => 'Immersive'},
    :document => {:singular => 'Document', :plural => 'Documents'}
    #:biblio => {:singular => 'Biblio', :plural => 'Biblio'}
  }
  
  default_scope :conditions => {:application_filter_id => ApplicationFilter.application_filter.id} if !ApplicationFilter.application_filter.nil?
  
  include Util, FileUtils, MediaProcessor::MediumExtension, FilenameUtils
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
  has_many :media_content_administrative_locations, :order => 'type DESC', :dependent => :destroy
  has_many :locations, :dependent => :destroy
  has_many :media_category_associations, :dependent => :destroy
  has_many :media_keyword_associations, :dependent => :destroy
  has_many :copyrights, :dependent => :destroy
  has_many :affiliations, :dependent => :destroy
  has_many :keywords, :through => :media_keyword_associations, :order => 'title'
  has_many :cumulative_media_category_associations, :dependent => :destroy
  has_many :titles, :dependent => :destroy
  
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
    delete_setting = ApplicationSetting.find_by_title('delete_from_cold_storage')
    delete_from_coldstorage if delete_setting.nil? || delete_setting.value==1
  end
  
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
    Location.where(:medium_id => self.id).count
  end
  
  def kmaps_url
    TopicalMapResource.get_url + medium_path
  end
  
  def places_url
    PlacesResource.get_url + medium_path
  end
  
  def thumbnail_image
    att = attachment
    return nil if att.nil?
    att.children.where(:thumbnail => 'compact').first
  end
  
  def screen_size_image
    att = attachment
    return nil if att.nil?
    #img = att.children.find(:first, :conditions => {:thumbnail => 'large'})
    #return img if !img.nil?
    img = att.children.where(:thumbnail => 'normal').first
    return img if !img.nil?
    img = att.children.where(:thumbnail => 'essay').first
    return img
  end
  
  def large_image
    att = attachment
    return nil if att.nil?
    att.children.where(:thumbnail => 'large').first
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

# == Schema Info
# Schema version: 20110412155958
#
# Table name: media
#
#  id                       :integer(4)      not null, primary key
#  application_filter_id    :integer(4)      not null
#  attachment_id            :integer(4)
#  capture_device_model_id  :integer(4)
#  photographer_id          :integer(4)
#  quality_type_id          :integer(4)
#  recording_orientation_id :integer(4)
#  resource_type_id         :integer(4)      not null
#  private_note             :text
#  recording_note           :text
#  rotation                 :integer(4)
#  type                     :string(10)      not null
#  created_on               :datetime
#  partial_taken_on         :string(255)
#  taken_on                 :datetime
#  updated_on               :datetime