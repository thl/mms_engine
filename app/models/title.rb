# == Schema Information
#
# Table name: titles
#
#  id          :integer          not null, primary key
#  title       :text             default(""), not null
#  creator_id  :integer
#  medium_id   :integer          not null
#  language_id :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Title < ActiveRecord::Base
  validates_presence_of :title, :medium_id, :language_id
  belongs_to :medium
  belongs_to :language, :class_name => 'ComplexScripts::Language'
  belongs_to :creator, :class_name => 'AuthenticatedSystem::Person', :foreign_key => 'creator_id'
  has_many   :translated_titles, dependent: :destroy
  has_many   :citations, as: :reference, dependent: :destroy
end