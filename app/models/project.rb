# == Schema Information
#
# Table name: projects
#
#  id    :integer          not null, primary key
#  title :string(250)      not null
#

class Project < ActiveRecord::Base
  validates_presence_of :title
  has_many :affiliations
end