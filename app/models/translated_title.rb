class TranslatedTitle < ActiveRecord::Base
  validates_presence_of :title, :title_id, :language_id
  belongs_to :parent_title, :class_name => 'Title', :foreign_key => 'title_id'
  belongs_to :language, :class_name => 'ComplexScripts::Language'
  belongs_to :creator, :class_name => 'Person', :foreign_key => 'creator_id'
  has_many   :citations, :as => :reference
end

# == Schema Info
# Schema version: 20100320035754
#
# Table name: translated_titles
#
#  id          :integer(4)      not null, primary key
#  creator_id  :integer(4)
#  language_id :integer(4)      not null
#  title_id    :integer(4)      not null
#  title       :string(255)     not null
#  created_at  :datetime
#  updated_at  :datetime