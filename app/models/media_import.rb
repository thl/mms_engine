class MediaImport
  attr_accessor :batch_processing_folder, :import_type_id, :media_classification_1, :media_classification_2,
    :media_classification_3, :has_images, :has_mediapro_metadata, :has_movies, :has_texts, :media_type_subfolder
  
  def initialize(params)
    params.each{|key, value| send("#{key}=",value) }
  end
end
