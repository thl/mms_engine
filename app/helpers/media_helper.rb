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
  
  def javascript_files
    super + ['swfobject', 'thickbox-compressed']
  end
  
  def stylesheet_files
    super + ['thickbox']
  end
end
