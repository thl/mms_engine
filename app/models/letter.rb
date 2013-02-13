class Letter < ActiveRecord::Base
  has_many :words, :dependent => :destroy, :order => '`order`'
  
  def self.letters_by_language(language_id)
    letter_ids = Rails.cache.fetch("letters/by_language/#{language_id}") { Word.where(['language_id = ? AND letter_id IS NOT NULL', 2]).select(:letter_id).uniq.order(:letter_id).collect(&:letter_id) }
    Letter.find(letter_ids)
  end
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: letters
#
#  id    :integer(4)      not null, primary key
#  order :integer(4)
#  title :string(10)      not null