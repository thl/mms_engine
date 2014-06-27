# == Schema Information
#
# Table name: renderers
#
#  id    :integer          not null, primary key
#  title :string(50)       default(""), not null
#  path  :string(200)      not null
#

class FileRenderer < ActiveRecord::Base
  attr_accessible :title, :path
  has_many :transformations
  table_name = 'renderers'
end