class GrammaticalClass < ActiveRecord::Base
  has_many :definitions, :dependent => :nullify
end

# == Schema Info
# Schema version: 20110228181402
#
# Table name: grammatical_classes
#
#  id    :integer(4)      not null, primary key
#  title :string(50)      not null