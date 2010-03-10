# == Schema Info
# Schema version: 20100310060934
#
# Table name: definitions
#
#  id                   :integer(4)      not null, primary key
#  definiendum_id       :integer(4)      not null
#  definition_id        :integer(4)      not null
#  dialect_id           :integer(4)
#  glossary_id          :integer(4)
#  grammatical_class_id :integer(4)
#  loan_type_id         :integer(4)

class Definition < ActiveRecord::Base
  belongs_to :definiendum, :class_name => 'Word', :foreign_key => 'definiendum_id'
  belongs_to :definition, :class_name => 'Word', :foreign_key => 'definition_id'
  belongs_to :grammatical_class
  belongs_to :loan_type
  belongs_to :dialect
  belongs_to :glossary
  has_and_belongs_to_many :keywords
end
