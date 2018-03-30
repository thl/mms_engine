# == Schema Information
#
# Table name: sponsors
#
#  id    :integer          not null, primary key
#  title :string(250)      not null
#

class Sponsor < ActiveRecord::Base
  validates_presence_of :title
  has_many :affiliations, dependent: :nullify
end