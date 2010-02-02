# == Schema Information
# Schema version: 20090626173648
#
# Table name: dialects
#
#  id    :integer(4)      not null, primary key
#  title :string(140)     not null
#

class Dialect < ActiveRecord::Base
  has_many :words
end
