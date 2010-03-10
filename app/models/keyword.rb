# == Schema Info
# Schema version: 20100310060934
#
# Table name: keywords
#
#  id    :integer(4)      not null, primary key
#  title :string(100)     not null

class Keyword < ActiveRecord::Base
  translates :title
  validates_presence_of :title
  validates_uniqueness_of :title  
  has_many :media_keyword_associations, :dependent => :destroy
  has_many :media, :through => :media_keyword_associations
  
  def self.all_tabulated_by_media
    Keyword.find_by_sql('SELECT keywords.*, count(*) as counted_media FROM media_keyword_associations, keywords WHERE keywords.id = media_keyword_associations.keyword_id GROUP BY keywords.id HAVING counted_media>15 ORDER BY RAND()')
  end
  
  def paged_media(limit, offset)
    Medium.find_by_sql(['SELECT media.* FROM media, media_keyword_associations WHERE media.id = media_keyword_associations.medium_id AND media_keyword_associations.keyword_id = ? LIMIT ?, ?', id, offset, limit])
  end
end
