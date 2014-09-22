# == Schema Information
#
# Table name: translated_titles
#
#  id          :integer          not null, primary key
#  title       :text             default(""), not null
#  creator_id  :integer
#  title_id    :integer          not null
#  language_id :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class TranslatedTitle < ActiveRecord::Base
  validates_presence_of :title, :title_id, :language_id
  belongs_to :parent_title, :class_name => 'Title', :foreign_key => 'title_id'
  belongs_to :language, :class_name => 'ComplexScripts::Language'
  belongs_to :creator, :class_name => 'AuthenticatedSystem::Person', :foreign_key => 'creator_id'
  has_many   :citations, :as => :reference
end