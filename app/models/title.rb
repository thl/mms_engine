# == Schema Info
# Schema version: 20100310060934
#
# Table name: titles
#
#  id          :integer(4)      not null, primary key
#  creator_id  :integer(4)
#  language_id :integer(4)      not null
#  medium_id   :integer(4)      not null
#  title       :string(255)     not null
#  created_at  :datetime
#  updated_at  :datetime

class Title < ActiveRecord::Base
  validates_presence_of :title, :medium_id, :language_id
  belongs_to :medium
  belongs_to :language, :class_name => 'ComplexScripts::Language'
  belongs_to :creator, :class_name => 'Person', :foreign_key => 'creator_id'
  has_many   :translated_titles
  has_many   :citations, :as => :reference
end
