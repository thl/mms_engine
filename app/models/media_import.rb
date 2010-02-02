class MediaImport
  attr_accessor :batch_processing_folder
  attr_accessor :import_type_id
  attr_accessor :media_classification_1
  attr_accessor :media_classification_2
  attr_accessor :media_classification_3
  attr_accessor :has_images
  attr_accessor :has_movies
  attr_accessor :has_texts
  attr_accessor :media_type_subfolder
  
  def initialize(params)
    params.each{|key, value| send("#{key}=",value) }
  end
end
