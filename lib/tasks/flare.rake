namespace :mms_engine do
  namespace :flare do
    desc "Reindex all media objects in solr. rake mms_engine:flare:reindex_all [FROM=id]"
    task :reindex_all => :environment do
      media = Medium.order(:id)
      from = ENV['FROM']
      media = media.where(['id >= ?', from.to_i]) if !from.blank?
      count = 0
      media.each do |m|
        if m.index
          puts "#{Time.now}: Reindexed #{m.id}."
          Picture.commit if (count+=1) % 1000 == 0 # Do commit every 1000 updates
        else
          puts "#{Time.now}: #{m.id} failed."
        end
      end
      Picture.commit
    end
  end
end