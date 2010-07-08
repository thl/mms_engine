class Letter < ActiveRecord::Base
  has_many :words, :dependent => :destroy, :order => '`order`'
  
  def self.letters_by_language(language_id)
    Letter.find_by_sql(['SELECT DISTINCT letters.* FROM letters, words WHERE words.letter_id = letters.id AND words.language_id = ? ORDER BY letters.`order`', language_id])
  end
end

# == Schema Info
# Schema version: 20100707151911
#
# Table name: letters
#
#  id    :integer(4)      not null, primary key
#  order :integer(4)
#  title :string(10)      not null