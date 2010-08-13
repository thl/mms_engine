class Renderer < ActiveRecord::Base
  has_many :transformations
end

# == Schema Info
# Schema version: 20100811203819
#
# Table name: renderers
#
#  id    :integer(4)      not null, primary key
#  path  :string(200)     not null
#  title :string(50)      not null, default("")