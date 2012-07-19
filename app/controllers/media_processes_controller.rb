require 'fileutils'

class MediaProcessesController < AclController
  include MediaProcessor::ControllerExtension
  
  @@media_process_types = { 'Cold storage partitioning' => 'partition_all_cold_storage', 'Path partitioning' => 'move_all_to_partitioned_paths', 'Rename' => 'rename_all', 'Thumb regeneration' => 'update_all_thumbnails', 'Update metadata from image properties' => 'update_from_image_properties', 'Update sizes' => 'update_all_sizes' }
  @@media_types = {'All' => Medium, 'Pictures' => Picture, 'Documents' => Document, 'Videos' => Video}
  @@storages = {'All' => ['images', 'movies', 'typescripts'], 'Pictures' => ['images'], 'Documents' => ['typescripts'], 'Videos' => ['movies']}
  @@attachments = {'Pictures' => [Image], 'Documents' => [Typescript], 'Videos' => [Movie]}
  
  # GET /media_processes
  # GET /media_processes.xml
  def index
    @active_users = users_with_active_forks
    @users_with_processes = users_with_forks
  end
  
  def status
    user_id = params[:user_id]
    if user_id.blank?
      @user = current_user
      user_id = @user.id
    else
      @user = AuthenticatedSystem::User.find(user_id)
    end
    done = fork_done?(user_id)
    @log = get_log_messages(user_id)
    if request.xhr?
      render :update do |page|
        if done
          page.redirect_to media_process_url(@user)
        else
          page.replace_html 'status', :partial => 'status'
        end
      end
    else
      if done
        render :action => 'done_status'
      else
        render :action => 'processing_status'
      end
    end
  end

  # GET /media_processes/1
  # GET /media_processes/1.xml
  def show
    user_id = params[:id]
    done = fork_done?(user_id)
    @log = get_log_messages(user_id)
    @user = AuthenticatedSystem::User.find(user_id)
    if done
      render :action => 'done_status'
    else
      render :action => 'processing_status'
    end    
  end

  # GET /media_processes/new
  # GET /media_processes/new.xml
  def new
    @media_process_types = @@media_process_types
    @media_types = @@media_types
  end
  
  # POST /media_processes
  # POST /media_processes.xml
  def create
    media_process = params[:media_process]
    id_start_str = media_process[:id_start]
    id_end_str = media_process[:id_end]
    process_type = media_process[:process_type]
    media_type = media_process[:media_type]
    if id_start_str.blank?
      id_start = nil
    else
      id_start = id_start_str.to_i
    end
    if id_end_str.blank?
      id_end = nil
    else
      id_end = id_end_str.to_i
    end
    allowed = true 
    if process_type.blank?
      allowed = false
    else
      case process_type
      when 'update_all_thumbnails'
        if media_type=='Pictures'
          update_all_thumbnails(id_start, id_end, @@media_types[media_type])
        elsif media_type=='Documents'
          create_all_previews_and_thumbnails
        end
      when 'rename_all'
        rename_all(id_start, id_end, @@media_types[media_type])
      when 'move_all_to_partitioned_paths'
        move_all_to_partitioned_paths(@@storages[media_type])
      when 'partition_all_cold_storage'
        partition_all_cold_storage(@@storages[media_type])
      when 'update_all_sizes'
        update_all_sizes(id_start, id_end, @@media_types[media_type])
      when 'update_from_image_properties'
        update_from_image_properties(id_start, id_end)
      end
    end
    if allowed
      redirect_to status_media_processes_url
    else
      @media_process_types = @@media_process_types
      @media_types = @@media_types
      render :action => 'new'
    end
  end
  
  # DELETE /media_processes/1
  # DELETE /media_processes/1.xml
  def destroy
    user_id = params[:id]
    delete_log(user_id)
    redirect_to status_media_processes_url
  end
end