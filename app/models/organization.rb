# == Schema Information
#
# Table name: organizations
#
#  id      :integer          not null, primary key
#  title   :string(250)      not null
#  website :string(255)
#

class Organization < ActiveRecord::Base
  attr_accessible :title, :website
  validates_presence_of :title
  has_many :affiliations
  has_many :glossaries
end