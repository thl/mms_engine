module MediaHelper
  def chosen_caption(medium)
    captions = medium.captions
    return nil if captions.empty?
    current_language = session[:language]
    for caption in captions
      if caption.language.code == current_language
        return caption
      end
    end
    return captions.first
  end
  
  def bookmark(name)
    tag :a, :name => name
  end
  
  def thumbnail_image_link(medium)
    thumbnail_image = medium.thumbnail_image
    thumbnail_image.nil? ? nil : link_to(image_tag(thumbnail_image.public_filename), medium_path(medium))
  end
  
  def javascript_files
    super + ['swfobject', 'thickbox-compressed']
  end
  
  def stylesheet_files
    super + ['thickbox']
  end
end
