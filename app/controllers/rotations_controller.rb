class RotationsController < AclController
  include ForkedNotifier
  
  before_filter :find_medium_and_user
  
  # GET /rotations
  # GET /rotations.xml
  def index
    render :partial => 'index' if request.xhr?
  end

  # GET /rotations/1
  # GET /rotations/1.xml
  def show
    @rotation = params[:id]
    if @rotation.blank? || @rotation.to_i.to_s != @rotation || Rotation.find_by_id(@rotation.to_i).nil?
      redirect_to medium_url(@medium)
    else
      respond_to do |format|
        format.html # show.html.erb
        format.jpg do
          image = Magick::Image.read(@medium.thumbnail_image.full_filename).first.rotate((360 - @medium.rotation.to_i + @rotation.to_i) % 360)
          send_data image.to_blob, :filename => "#{@rotation}.jpg", :disposition => 'inline', :type => 'image/jpeg'
        end
      end
    end
  end

  # POST /rotations
  def create
    if @medium.update_attributes(params[:medium])
      if request.xhr?
        register_active_process
        start_log('Beginning rotation.')
        write_to_log("Spawning main process #{Process.pid}.")
        write_to_log("Rotating medium #{@medium.id}.")
        background_process do
          begin
            @medium.update_thumbnails
          rescue Exception => exc
            finish_log("Rotation was abruptly terminated: #{exc.to_s}")
          else
            finish_log("Rotation finished normally.")
          end
        end
        render(:update) { |page| page.replace_html 'edit_div', :partial => 'rotations/notice' }
      else
        flash[:notice] = 'Rotation was successfully updated.'
        redirect_to medium_url(@medium)
      end
    else
      render :action => "index"
    end
  end
  
  def status
    done = fork_done?(@user.id)
    @log = get_log_messages(@user.id)
    if request.xhr?
      render :update do |page|
        page.reload if done
      end
    else
      if done
        render :action => 'done_status'
      else
        render :action => 'processing_status'
      end
    end
  end
  
  private
  
  def find_medium_and_user
    begin
      medium_id = params[:medium_id]
      @medium = medium_id.blank? ? nil : Medium.find(medium_id)
    rescue ActiveRecord::RecordNotFound
      @medium = nil
    end
    if @medium.nil?
      flash[:notice] = 'Attempt to access invalid medium.'
      redirect_to media_path
    else
      user_id = params[:user_id]
      @user = user_id.blank? ? current_user : User.find(user_id)
    end
  end
  
  def log_suffix
    return "rotating_#{@medium.id}"
  end
end
