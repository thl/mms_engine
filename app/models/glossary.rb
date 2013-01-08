class Glossary < ActiveRecord::Base
  attr_accessible :title, :abbreviation, :organization_id, :description
  has_many :definitions
  belongs_to :organization
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: glossaries
#
#  id              :integer(4)      not null, primary key
#  organization_id :integer(4)
#  abbreviation    :string(20)
#  description     :text
#  is_public       :boolean(1)      not null, default(TRUE)
#  title           :string(255)     not null