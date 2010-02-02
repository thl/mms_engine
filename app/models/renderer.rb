# == Schema Information
# Schema version: 20090626173648
#
# Table name: renderers
#
#  id    :integer(4)      not null, primary key
#  title :string(50)      default(""), not null
#  path  :string(200)     not null
#

class Renderer < ActiveRecord::Base
  has_many :transformations
end
