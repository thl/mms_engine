class TopicsController < ApplicationController
  helper :media
  
  # GET /places/1
  # GET /places/1.xml
  def show
    @topic = Topic.find(params[:id])
    medium_id = params[:medium_id]
    @medium = nil
    if !medium_id.blank?
      begin
        @medium = Medium.find(medium_id)
      rescue ActiveRecord::RecordNotFound
        @medium = nil
      end
    end
    @pictures = @topic.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Picture')
    @videos = @topic.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Video')
    @documents = @topic.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Document')
    title = @topic.title
    @titles = { :picture => ts(:in, :what => Picture.human_name(:count => :many).titleize, :where => title), :video => ts(:in, :what => Video.human_name(:count => :many).titleize, :where => title), :document => ts(:in, :what => Document.human_name(:count => :many).titleize, :where => title) }
    @more = { :category_id => @topic.id, :type => '' }    
    if request.xhr?
      render :update do |page|
        if !@medium.nil?
          page.replace_html 'primary', :partial => 'media/show'
        end
        page.replace_html 'secondary', :partial => 'media_index'
        page.call 'tb_init', 'a.thickbox, area.thickbox, input.thickbox'
      end
    else
      respond_to { |format| format.html { render(:action => 'show_for_medium') if !@medium.nil? } }
    end
  end
end