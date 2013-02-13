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
    ComplexScripts::Language.find(language_ids)
  end

  def self.head_term_languages
    language_ids = Rails.cache.fetch('words/head_term_languages') { Word.find_by_sql("SELECT DISTINCT language_id FROM words WHERE id IN (SELECT DISTINCT definiendum_id FROM definitions)").collect(&:language_id) }
    ComplexScripts::Language.find(language_ids)
  end
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: words
#
#  id          :integer(4)      not null, primary key
#  language_id :integer(4)      not null
#  letter_id   :integer(4)
#  order       :integer(4)
#  title       :text            not null, default("")