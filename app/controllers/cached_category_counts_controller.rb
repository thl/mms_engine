class CachedCategoryCountsController < ApplicationController
  caches_page :index, :if => :api_response?.to_proc
  
  # GET /cached_category_counts.xml
  def index
    Dir.foreach(File.join(File.dirname(__FILE__), '..', 'models')) { |file_name| require_dependency(file_name) if /.rb$/ =~ file_name }
    @category_id = params[:category_id].to_i
    @cached_category_counts = ([nil] + subclasses_of(Medium).collect(&:name)).collect {|medium_type| CachedCategoryCount.updated_count(@category_id, medium_type)}
    respond_to do |format|
      format.xml { render :xml => @cached_category_counts.to_xml }
    end
  end
  
  private
  
  def api_response?
    request.format.xml?
  end
end
