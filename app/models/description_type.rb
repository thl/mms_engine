# == Schema Info
# Schema version: 20100310060934
#
# Table name: description_types
#
#  id    :integer(4)      not null, primary key
#  title :string(100)     not null

class DescriptionType < ActiveRecord::Base
 validates_presence_of :title
  has_many :captions  
  has_many :descriptions

end
