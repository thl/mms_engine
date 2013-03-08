# == Schema Information
#
# Table name: sponsors
#
#  id    :integer          not null, primary key
#  title :string(250)      not null
#

class Sponsor < ActiveRecord::Base
  attr_accessible :title
  validates_presence_of :title
  has_many :affiliations
end