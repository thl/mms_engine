# == Schema Information
#
# Table name: glossaries
#
#  id              :integer          not null, primary key
#  title           :string(255)      not null
#  description     :text
#  abbreviation    :string(20)
#  organization_id :integer
#  is_public       :boolean          default(TRUE), not null
#

class Glossary < ActiveRecord::Base
  has_many :definitions, dependent: :nullify
  belongs_to :organization
end