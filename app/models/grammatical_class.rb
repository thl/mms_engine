# == Schema Information
# Schema version: 20090626173648
#
# Table name: grammatical_classes
#
#  id    :integer(4)      not null, primary key
#  title :string(50)      not null
#

class GrammaticalClass < ActiveRecord::Base
  has_many :definitions, :dependent => :nullify
end
