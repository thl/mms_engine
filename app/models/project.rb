# == Schema Info
# Schema version: 20100310060934
#
# Table name: projects
#
#  id    :integer(4)      not null, primary key
#  title :string(250)     not null

class Project < ActiveRecord::Base
 validates_presence_of :title
 has_many :affiliations
end
