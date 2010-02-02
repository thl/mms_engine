# == Schema Information
# Schema version: 20090626173648
#
# Table name: glossaries
#
#  id              :integer(4)      not null, primary key
#  title           :string(255)     not null
#  description     :text
#  abbreviation    :string(20)
#  organization_id :integer(4)
#  is_public       :boolean(1)      default(TRUE), not null
#

class Glossary < ActiveRecord::Base
  has_many :definitions
  belongs_to :organization
end
