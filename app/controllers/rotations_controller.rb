class RotationsController < ApplicationController
  before_filter :find_medium
  
  # GET /rotations
  # GET /rotations.xml
  def index
    @rotations = Rotation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rotations }
    end
  end

  # GET /rotations/1
  # GET /rotations/1.xml
  def show
    rotation = params[:id]
    redirect_to medium_url(@medium) if rotation.blank? || rotation.to_i.to_s != rotation || ![0, 90, 180, 270].include?(rotation.to_i)
    respond_to do |format|
      format.jpg do
        image = Magick::Image.read(@medium.thumbnail_image.full_filename).first.rotate(rotation.to_i)
        send_data image.to_blob, :filename => "#{rotation}.jpg", :disposition => 'inline', :type => 'image/jpeg'
      end
    end
  end

  # GET /rotations/1/edit
  def edit
    @rotation = Rotation.find(params[:id])
  end

  # PUT /rotations/1
  # PUT /rotations/1.xml
  def update
    @rotation = Rotation.find(params[:id])

    respond_to do |format|
      if @rotation.update_attributes(params[:rotation])
        flash[:notice] = 'Rotation was successfully updated.'
        format.html { redirect_to(@rotation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rotation.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  
  def find_medium
    begin
      medium_id = params[:medium_id]
      @medium = medium_id.blank? ? nil : Medium.find(medium_id)
    rescue ActiveRecord::RecordNotFound
      @medium = nil
    end
    if @medium.nil?
      flash[:notice] = 'Attempt to access invalid medium.'
      redirect_to media_path
    end
  end
end
