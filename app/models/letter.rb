# == Schema Information
#
# Table name: letters
#
#  id    :integer          not null, primary key
#  title :string(10)       not null
#  order :integer
#

class Letter < ActiveRecord::Base
  has_many :words, :dependent => :destroy, :order => '`order`'
  
  def self.letters_by_language(language_id)
    letter_ids = Rails.cache.fetch("letters/by_language/#{language_id}") { Word.where(['language_id = ? AND letter_id IS NOT NULL', 2]).select(:letter_id).uniq.order(:letter_id).collect(&:letter_id) }
    letter_ids.collect{ |id| Letter.find(id) }
  end
end