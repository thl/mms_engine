# == Schema Information
#
# Table name: grammatical_classes
#
#  id    :integer          not null, primary key
#  title :string(50)       not null
#

class GrammaticalClass < ActiveRecord::Base
  has_many :definitions, :dependent => :nullify
end