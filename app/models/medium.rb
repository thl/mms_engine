# == Schema Information
# Schema version: 20090626173648
#
# Table name: media
#
#  id                       :integer(4)      not null, primary key
#  photographer_id          :integer(4)
#  quality_type_id          :integer(4)
#  created_on               :datetime
#  updated_on               :datetime
#  recording_note           :text
#  private_note             :text
#  type                     :string(10)      not null
#  attachment_id            :integer(4)      not null
#  taken_on                 :datetime
#  recording_orientation_id :integer(4)
#  capture_device_model_id  :integer(4)
#  partial_taken_on         :string(255)
#

require 'fileutils'

class Medium < ActiveRecord::Base
  include FilenameUtils
  
  ROWS = 5
  PREVIEW_ROWS = 2
  COLS = 4
  
  COMMON_SIZES = {:compact => '70:95x95#', :thumb => '70:120x120#', :essay => '80:280x280>'}
  
  include Util, FileUtils, MediaProcessor::MediumExtension
  
  belongs_to :photographer, :class_name => 'Person', :foreign_key => 'photographer_id'
  belongs_to :quality_type
  belongs_to :recording_orientation
  belongs_to :capture_device_model
  has_and_belongs_to_many :captions
  has_and_belongs_to_many :descriptions
  has_and_belongs_to_many :sources
  has_one :workflow, :dependent => :destroy
  has_one  :media_recording_administrative_location, :dependent => :destroy
  has_many :media_source_associations, :dependent => :destroy
  has_many :sources, :through => :media_source_associations
  has_many :media_content_administrative_locations, :order => 'DESC type', :dependent => :destroy
  has_many :media_administrative_locations, :dependent => :destroy
  has_many :media_category_associations, :dependent => :destroy
  has_many :media_keyword_associations, :dependent => :destroy
  has_many :copyrights, :dependent => :destroy
  has_many :affiliations, :dependent => :destroy
  has_many :administrative_units, :through => :media_administrative_locations
  has_many :keywords, :through => :media_keyword_associations, :order => 'title'
  has_many :cumulative_media_category_associations, :dependent => :destroy

  def media_collection_associations
    self.media_category_associations.find(:all, :conditions => {:root_id => Collection.root_id})
  end
  
  def media_subject_associations
    self.media_category_associations.find(:all, :conditions => {:root_id => Subject.root_id})
  end
    
  def media_ethnicity_associations
    self.media_category_associations.find(:all, :conditions => {:root_id => Ethnicity.root_id})
  end
  
  def collections
    self.media_collection_associations.collect(&:category)
  end

  def subjects
    self.media_subject_associations.collect(&:category)
  end

  def ethnicities
    self.media_ethnicity_associations.collect(&:category)
  end
  
  def thumbnail_image
    att = attachment
    return nil if att.nil?
    att.children.find(:first, :conditions => {:thumbnail => 'compact'} )
  end
  
  def screen_size_image
    att = attachment
    return nil if att.nil?
    att.children.find(:first, :conditions => {:thumbnail => 'essay'} )
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
  
  #not meant to be called in itself but within the count_media of administrative_units, subjects, collections, and ethnicities
  def self.count_media(descendant_ids, type = nil)
    conditions_string = String.new
    conditions_array = Array.new
    if !type.nil?
      conditions_string = 'AND media.type = ?'
      conditions_array << type
    end
    [conditions_string] + descendant_ids + conditions_array
  end    
      
  def self.paged_media_search(media_search, limit, offset)
    # for now asumming that its English; change later TODO 
    Medium.find_by_sql(["(SELECT media.* FROM media, captions, captions_media WHERE captions_media.medium_id = media.id AND captions_media.caption_id = captions.id AND " + Util.search_condition_string(media_search.type, 'captions.title', true) + ") UNION (SELECT media.* FROM media, descriptions, descriptions_media WHERE descriptions_media.medium_id = media.id AND descriptions_media.description_id = descriptions.id AND " + Util.search_condition_string(media_search.type, 'descriptions.title', true) + ") LIMIT ?, ?", media_search.title, media_search.title, offset, limit])    
  end
  
  def self.count_media_search(media_search)
    # for now asumming that its English; change later TODO
    number_of_captions = Medium.count_by_sql(["SELECT COUNT(*) FROM captions WHERE " + Util.search_condition_string(media_search.type, 'title', true), media_search.title])
    number_of_descriptions = Medium.count_by_sql(["SELECT COUNT(*) FROM descriptions WHERE " + Util.search_condition_string(media_search.type, 'title', true), media_search.title]) 
    number_of_captions + number_of_descriptions 
  end
  
  def self.range(id_start, id_end)
    if id_end.nil?
      if id_start.nil?
        media = self.find(:all)
      else
        media = self.find(:all, :conditions => ['id >= ?', id_start])
      end
    else
      if id_start.nil?
        media = self.find(:all, :conditions => ['id <= ?', id_end])
      else
        media = self.find(:all, :conditions => ['id >= ? AND id <= ?', id_start, id_end])
      end
    end   
  end
  
  def after_create
    # TODO: handle if it couldn't be saved
    rename
  end

  def before_destroy
    captions_array = captions
    for caption in captions_array
      caption.destroy
    end
    captions.clear
    descriptions_array = descriptions
    for description in descriptions_array
      description.destroy
    end
    descriptions.clear
    delete_from_coldstorage
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
    if !cold_storage_file.nil? && File.exist?(cold_storage_file)
      return cold_storage_file
    else
      return nil
    end
  end
  
  private
      
  def delete_from_coldstorage
    message = String.new
    if self.class==Document
      return message
    elsif self.class==Picture
      media_folder = 'images'
    elsif self.class==Video
      media_folder = 'movies'
    end
    actual_media = attachment_id
    begin
      cold_storage_folder = ApplicationSetting.cold_storage_folder
      if !cold_storage_folder.nil?
        media_full_path = File.join(cold_storage_folder, media_folder)
        if File.exist?(media_full_path)
          original = File.join(media_full_path, id_name)
          rm_f(original) if File.exist?(original)
        end
      end
    rescue Exception => exc
      message << "#{exc.to_s}<br/>"
    end
  end
end