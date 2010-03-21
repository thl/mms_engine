class Keyword < ActiveRecord::Base
  translates :title
  validates_presence_of :title
  validates_uniqueness_of :title  
  has_many :media_keyword_associations, :dependent => :destroy
  has_many :media, :through => :media_keyword_associations
  
  def self.all_tabulated_by_media
    if ApplicationFilter.application_filter.nil?
      Keyword.find_by_sql('SELECT keywords.*, count(*) as counted_media FROM media_keyword_associations, keywords WHERE keywords.id = media_keyword_associations.keyword_id GROUP BY keywords.id HAVING counted_media>15 ORDER BY RAND()')
    else
      Keyword.find_by_sql(['SELECT keywords.*, count(*) as counted_media FROM media_keyword_associations, keywords, media WHERE keywords.id = media_keyword_associations.keyword_id AND media_keyword_associations.medium_id = media.id AND media.application_filter_id = ? GROUP BY keywords.id HAVING counted_media > ? ORDER BY RAND()', ApplicationFilter.application_filter.id, 15])
    end
  end
  
  def paged_media(limit, offset)
    if ApplicationFilter.application_filter.nil?
      Medium.find_by_sql(['SELECT media.* FROM media, media_keyword_associations WHERE media.id = media_keyword_associations.medium_id AND media_keyword_associations.keyword_id = ? LIMIT ?, ?', id, offset, limit])
    else
      Medium.find_by_sql(['SELECT media.* FROM media, media_keyword_associations WHERE media.application_filter_id = ? AND media.id = media_keyword_associations.medium_id AND media_keyword_associations.keyword_id = ? LIMIT ?, ?', ApplicationFilter.application_filter.id, id, offset, limit])
    end
  end
end

# == Schema Info
# Schema version: 20100320035754
#
# Table name: keywords
#
#  id    :integer(4)      not null, primary key
#  title :string(100)     not null