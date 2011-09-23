require 'config/environment'
namespace :mms do
  namespace :cache do
    cummulative_categories_cleanup_description = "Deletes cummulative information"    
    desc cummulative_categories_cleanup_description
    task :cummulative_categories_cleanup do |t|
      [CumulativeMediaCategoryAssociation, CachedCategoryCount].each { |model| model.connection.execute("TRUNCATE TABLE #{model.table_name}") }
      options = {:group =>'category_id', :order => 'category_id'}
      options.merge!({:joins => :medium, :conditions => {'media.application_filter_id' => ApplicationFilter.application_filter.id}}) if !ApplicationFilter.application_filter.nil?
      MediaCategoryAssociation.find(:all, options).collect(&:category).each do |category|
        medium_ids = ApplicationFilter.application_filter.nil? ? MediaCategoryAssociation.find(:all, :conditions => {:category_id => category.id}).collect(&:medium_id) : MediaCategoryAssociation.find(:all, :joins => :medium, :conditions => {:category_id => category.id, 'media.application_filter_id' => ApplicationFilter.application_filter.id}).collect(&:medium_id)
        ([category] + category.ancestors).each{ |c| medium_ids.each { |medium_id| CumulativeMediaCategoryAssociation.create(:category => c, :medium_id => medium_id) if CumulativeMediaCategoryAssociation.find(:first, :conditions => {:category_id => c.id, :medium_id => medium_id}).nil? } }
      end
    end
    
    desc 'Deletes media category count caches'
    task :category_counts_cleanup do |t|
      CachedCategoryCount.connection.execute("TRUNCATE TABLE #{CachedCategoryCount.table_name}")
    end
    
    desc "Deletes view cache"
    task :view_cleanup do |t|
      ['categories', 'documents', 'media_objects', 'places'].each{ |folder| `rm -rf #{File.join('public', folder)}` }
      `rm -rf #{File.join('tmp', 'cache', 'views')}`
    end
  end
end