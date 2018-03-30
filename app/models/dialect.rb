# == Schema Information
#
# Table name: dialects
#
#  id    :integer          not null, primary key
#  title :string(140)      not null
#

class Dialect < ActiveRecord::Base
  has_many :words, dependent: :nullify
end