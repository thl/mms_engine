# == Schema Information
#
# Table name: definitions
#
#  id                   :integer          not null, primary key
#  definiendum_id       :integer          not null
#  definition_id        :integer          not null
#  grammatical_class_id :integer
#  loan_type_id         :integer
#  dialect_id           :integer
#  glossary_id          :integer
#

class Definition < ActiveRecord::Base
  belongs_to :definiendum, :class_name => 'Word', :foreign_key => 'definiendum_id'
  belongs_to :definition, :class_name => 'Word', :foreign_key => 'definition_id'
  belongs_to :grammatical_class
  belongs_to :loan_type
  belongs_to :dialect
  belongs_to :glossary
  has_and_belongs_to_many :keywords
end