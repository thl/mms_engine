# == Schema Information
#
# Table name: words
#
#  id          :integer          not null, primary key
#  title       :text             default(""), not null
#  language_id :integer          not null
#  order       :integer
#  letter_id   :integer
#

class Word < ActiveRecord::Base
  belongs_to :language, :class_name => 'ComplexScripts::Language'
  belongs_to :letter
  has_many :definitions, :foreign_key => 'definiendum_id'
  
  def definienda
    Word.find_by_sql(['SELECT words.* FROM words, definitions WHERE definitions.definition_id = ? AND words.id = definitions.definiendum_id', id])
  end
  
  def definitions_of_definienda
    Definition.find_by_sql(['SELECT * FROM definitions WHERE definitions.definition_id = ?', id])
  end  

  def self.available_languages
    language_ids = Rails.cache.fetch('words/available_languages'){ Word.select('language_id').uniq.order('language_id').collect(&:language_id) }
    language_ids.collect{ |id| ComplexScripts::Language.find(id) }
  end

  def self.head_term_languages
    language_ids = Rails.cache.fetch('words/head_term_languages') { Word.find_by_sql("SELECT DISTINCT language_id FROM words WHERE id IN (SELECT DISTINCT definiendum_id FROM definitions)").collect(&:language_id) }
    language_ids.collect{ |id| ComplexScripts::Language.find(id) }
  end
end
