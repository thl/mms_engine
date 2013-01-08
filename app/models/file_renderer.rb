class FileRenderer < ActiveRecord::Base
  attr_accessible :title, :path
  set_table_name 'renderers'
  has_many :transformations
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: renderers
#
#  id    :integer(4)      not null, primary key
#  path  :string(200)     not null
#  title :string(50)      not null, default("")