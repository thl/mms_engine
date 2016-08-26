namespace :mms_engine do
  namespace :flare do
    desc "Reindex all media objects in solr. rake mms_engine:flare:reindex_all [FROM=id]"
    task :reindex_all => :environment do
      media = Medium.order(:id)
      from = ENV['FROM']
      media = media.where(['id >= ?', from.to_i]) if !from.blank?
      media.each do |m|
        if m.update_solr
          puts "#{Time.now}: Reindexed #{m.id}."
        else
          puts "#{Time.now}: #{m.id} failed."
        end
      end
    end
  end
end