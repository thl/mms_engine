class CachedCategoryCountsController < ApplicationController
  caches_page :index, :if => Proc.new { |c| c.request.format.xml? }
  
  
  # GET /cached_category_counts.xml
  def index
    Dir.foreach(File.join(__dir__, '..', 'models')) { |file_name| require_dependency(file_name) if /.rb$/ =~ file_name }
    category_id = params[:category_id].to_i
    cached_category_counts = ([nil] + Medium.descendants.collect(&:name)).collect {|medium_type| CachedCategoryCount.updated_count(category_id, medium_type)}
    respond_to do |format|
      format.xml { render :xml => cached_category_counts.to_xml }
    end
  end
end
