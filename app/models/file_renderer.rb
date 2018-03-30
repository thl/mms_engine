# == Schema Information
#
# Table name: renderers
#
#  id    :integer          not null, primary key
#  title :string(50)       default(""), not null
#  path  :string(200)      not null
#

class FileRenderer < ActiveRecord::Base
  has_many :transformations, dependent: :nullify
  self.table_name = 'renderers'
end