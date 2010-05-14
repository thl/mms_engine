require 'config/environment'

module DocumentProcessing
  def self.caption_to_title
    Document.find(:all, :order => :id).each do |document|
      captions = document.captions
      next if captions.size != 1
      caption = captions.first
      titles = document.titles
      next if !titles.empty?
      titles.create :title => caption.title, :language => caption.language, :creator => caption.creator
      caption.destroy
    end
  end
end