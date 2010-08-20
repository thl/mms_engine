class PlaceCountsController < ApplicationController
  caches_page :index, :if => :api_response?.to_proc
  
  # GET /cached_category_counts.xml
  def index
    Dir.foreach(File.join(File.dirname(__FILE__), '..', 'models')) { |file_name| require_dependency(file_name) if /.rb$/ =~ file_name }
    feature_id = params[:place_id].to_i
    place_counts = ([nil] + subclasses_of(Medium).collect(&:name)).collect do |medium_type|
      if medium_type.nil?
        {:medium_type => nil, :count => Location.count(:conditions => {:feature_id => feature_id})}
      else
        {:medium_type => medium_type, :count => Location.count(:conditions => {'media.type' => medium_type, 'locations.feature_id' => feature_id}, :joins => :medium)}
      end
    end
    respond_to do |format|
      format.xml { render :xml => place_counts.to_xml }
    end
  end
  
  private
  
  def api_response?
    request.format.xml?
  end
end
