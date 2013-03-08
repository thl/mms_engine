module FilenameUtils
  def FilenameUtils.extension(filename)
    File.extname(filename)
  end
  
  def FilenameUtils.extension_without_dot(filename)
    ext = FilenameUtils.extension(filename)
    ext = ext[1...ext.size] if !ext.blank?
    return ext
  end
  
  def FilenameUtils.basename(filename)
    File.basename(filename, '.*')
  end
  
  def extension(filename)
    FilenameUtils.extension(filename)
  end
  
  def extension_without_dot(filename)
    FilenameUtils.extension_without_dot(filename)
  end
  
  def basename(filename)
    FilenameUtils.basename(filename)
  end
end