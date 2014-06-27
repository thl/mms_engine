# require 'config/environment'
namespace :mms do
  namespace :cache do
    cummulative_categories_cleanup_description = "Deletes cummulative category information"
    desc cummulative_categories_cleanup_description
    task :cumulative_categories_cleanup => :environment do |t|
      [CumulativeMediaCategoryAssociation, CachedCategoryCount].each { |model| model.connection.execute("TRUNCATE TABLE #{model.table_name}") }
      associations = MediaCategoryAssociation.group('category_id').order('category_id')
      associations = associations.joins(:medium).where('media.application_filter_id' => ApplicationFilter.application_filter.id) if !ApplicationFilter.application_filter.nil?
      associations.collect(&:category).each do |category|
        medium_ids = ApplicationFilter.application_filter.nil? ? MediaCategoryAssociation.where(:category_id => category.id).collect(&:medium_id) : MediaCategoryAssociation.find(:all, :joins => :medium, :conditions => {:category_id => category.id, 'media.application_filter_id' => ApplicationFilter.application_filter.id}).collect(&:medium_id)
        ([category] + category.ancestors).each{ |c| medium_ids.each { |medium_id| CumulativeMediaCategoryAssociation.create(:category_id => c.id, :medium_id => medium_id) if CumulativeMediaCategoryAssociation.find(:first, :conditions => {:category_id => c.id, :medium_id => medium_id}).nil? } }
      end
    end
    
    cummulative_locations_cleanup_description = "Deletes cummulative locations information"
    desc cummulative_locations_cleanup_description
    task :cumulative_locations_cleanup => :environment do |t|
      CumulativeMediaLocationAssociation.connection.execute('TRUNCATE TABLE cumulative_media_location_associations')
      associations = Location.select('feature_id').group('feature_id').order('feature_id')
      associations = associations.joins(:medium).where('media.application_filter_id' => ApplicationFilter.application_filter.id) if !ApplicationFilter.application_filter.nil?
      associations.collect(&:feature).each do |feature|
        medium_ids = ApplicationFilter.application_filter.nil? ? Location.where(:feature_id => feature.id).collect(&:medium_id) : Location.joins(:medium).where(:feature_id => feature.id, 'media.application_filter_id' => ApplicationFilter.application_filter.id).collect(&:medium_id)
        ([feature] + feature.ancestors).each { |f| medium_ids.each { |medium_id| CumulativeMediaLocationAssociation.create(:feature_id => f.id, :medium_id => medium_id) if CumulativeMediaLocationAssociation.where(:feature_id => f.id, :medium_id => medium_id).first.nil? } }
      end
    end
    
    desc 'Deletes media category count caches'
    task :category_counts_cleanup => :environment do |t|
      CachedCategoryCount.connection.execute("TRUNCATE TABLE #{CachedCategoryCount.table_name}")
    end
    
    desc "Deletes view cache"
    task :view_cleanup do |t|
      ['categories', 'documents', 'media_objects', 'places'].each{ |folder| `rm -rf #{File.join('public', folder)}` }
      `rm -rf #{File.join('tmp', 'cache', 'views')}`
    end
  end
end