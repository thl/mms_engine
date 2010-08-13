class Document < Medium
  # The preview is generated in the highest possible resolution.  
  PREVIEW_TYPE = :huge
  belongs_to :typescript, :foreign_key => 'attachment_id'
  
  def attachment
    typescript
  end
  
  def before_destroy
    super
    typescript.destroy if !typescript.nil?
  end
  
  def thumbnail_image
    att = attachment
    return nil if att.nil?
    att.children.find(:first, :conditions => {:thumbnail => 'thumb'} )
  end
  
  def screen_size_image
    att = attachment
    return nil if att.nil?
    att.children.find(:first, :conditions => {:thumbnail => 'normal'} )
  end
    
  def self.public_folder
    'typescripts'
  end
  
  def prioritized_title
    titles = self.titles.find(:all, :order => :id)
    return titles.empty? ? self.id.to_s : titles.first.title
  end
  
  # Used to generate a preview of the document. For now, it only works with PDFs.
  def create_preview
    typescript = self.typescript
    return false if typescript.nil?
    full_filename = typescript.full_filename
    thumbnail = Magick::Image.read(full_filename).first
    quality = ImageUtils::resize_image(thumbnail, Medium::COMMON_SIZES[PREVIEW_TYPE])
    filename_ending = "_#{PREVIEW_TYPE.to_s}.jpg"
    pos = full_filename.rindex('.')
    full_path = full_filename[0...pos] + filename_ending
    thumbnail.write(full_path) do
      self.quality = quality if !quality.nil?
      self.format = 'JPG'
    end
    filename = typescript.filename
    pos = filename.rindex('.')
    preview = Typescript.new :content_type => 'image/jpeg', :filename => filename[0...pos] + filename_ending, :size => File.size(full_path), :parent_id => typescript.id, :thumbnail => PREVIEW_TYPE.to_s, :width => thumbnail.columns, :height => thumbnail.rows
    preview.save
  end
  
  # This method assumes that there is already a "preview" image under the typescript.
  def create_thumbnails
    typescript = self.typescript
    preview = typescript.children.first(:conditions => {:thumbnail => PREVIEW_TYPE.to_s})
    return false if preview.nil?
    full_filename = typescript.full_filename
    pos = full_filename.rindex('.')
    main_full_beginning = full_filename[0...pos]
    filename = typescript.filename
    pos = filename.rindex('.')
    main_beginning = filename[0...pos]
    preview_full_filename = preview.full_filename
    ['essay', 'compact'].each do |type|
      thumbnail = Magick::Image.read(preview_full_filename).first
      quality = ImageUtils::resize_image(thumbnail, Medium::COMMON_SIZES[type.to_sym])
      # write file
      filename_ending = "_#{type}.jpg"
      full_path = main_full_beginning + filename_ending
      thumbnail.write(full_path) do
        self.quality = quality if !quality.nil?
        self.format = 'JPG'
      end
      # create db record
      Typescript.create :content_type => 'image/jpeg', :filename => main_beginning + filename_ending, :size => File.size(full_path), :parent_id => typescript.id, :thumbnail => type, :width => thumbnail.columns, :height => thumbnail.rows    
    end
  end
  
  def self.paged_media_search(media_search, limit = 10, offset = 0)
    super(media_search, limit, offset, 'Document')
  end
end

# == Schema Info
# Schema version: 20100811203819
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
#  private_note             :text
#  recording_note           :text
#  type                     :string(10)      not null
#  created_on               :datetime
#  partial_taken_on         :string(255)
#  taken_on                 :datetime
#  updated_on               :datetime