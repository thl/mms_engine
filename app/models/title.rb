class Title < ActiveRecord::Base
  validates_presence_of :title, :medium_id, :language_id
  belongs_to :medium
  belongs_to :language, :class_name => 'ComplexScripts::Language'
end
