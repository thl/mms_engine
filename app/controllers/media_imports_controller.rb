require 'fileutils'

class MediaImportsController < AclController
  include MultimediaImportation
  
  cache_sweeper :media_category_association_sweeper, :only => [:create]
  cache_sweeper :document_sweeper, :only => [:create]
  
  @@import_types = ['File copy (no db manipulation)', 'Add new media to db', 'Update media file']
  @@media_classification = ['topic', 'place', 'recording_note']
    
  # GET /media_imports
  # GET /media_imports.xml
  def index
    @active_users = users_with_active_forks
    @users_with_imports = users_with_forks
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
          page.redirect_to media_import_url(@user)
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

  # GET /media_imports/1
  # GET /media_imports/1.xml
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

  # GET /media_imports/new
  # GET /media_imports/new.xml
  def new
    setting = ApplicationSetting.find_by_title('batch_processing_folder')
    @folder = setting.nil? ? '' : setting.string_value
    @import_types = Array.new
    @@import_types.each_with_index {|name, index| @import_types << [name, index] }
    @media_classification = @@media_classification.each {|name| [name.humanize, name] }
    @media_import = MediaImport.new(:batch_processing_folder => '', :import_type_id => 1, :has_images => true, :media_type_subfolder => 'no', :media_classification_1 => 'collection')

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @media_import }
    end
  end

  # POST /media_imports/confirm
  # POST /media_imports/confirm.xml
  def confirm
    media_import = MediaImport.new(params[:media_import])
    setting = ApplicationSetting.find_by_title('batch_processing_folder')
    folder = setting.nil? ? '' : setting.string_value
    source_folder = File.expand_path(Rails.root.join(folder, media_import.batch_processing_folder))
    no_subfolder = media_import.media_type_subfolder=='no'
    types_to_import = Array.new
    types_to_import << 'images' if media_import.has_images.to_i==1
    types_to_import << 'movies' if media_import.has_movies.to_i==1
    types_to_import << 'typescripts' if media_import.has_texts.to_i==1
    import_type_id = media_import.import_type_id.to_i
    case import_type_id
    when 0 # File copy (no db manipulation)
      begin
        destination_folder = File.expand_path(Rails.root.join('public'))
        if no_subfolder
          subfolder = types_to_import.first
          get_folder_names("#{source_folder}").each { |folder| cp_r(File.join(source_folder, folder), File.join(destination_folder, subfolder)) }
        else
          types_to_import.each {|type| copy_folders(source_folder, destination_folder, type) }
        end
      rescue Exception => exc
        flash[:notice] = "Import failed: #{exc.to_s}"
        redirect_to new_media_import_url
      else
        flash[:notice] = 'Media has been imported.'        
        redirect_to admin_url
      end
    when 1..2 # Add new media to db & update media files
      begin
        @media = Array.new
        @classifications = [media_import.media_classification_1]
        @classifications << media_import.media_classification_2 if !media_import.media_classification_2.blank?
        @classifications << media_import.media_classification_3 if !media_import.media_classification_3.blank?
        @import_type = {:title => @@import_types[import_type_id], :id => import_type_id}
        for type in types_to_import
          actual_folder = no_subfolder ? source_folder : File.join(source_folder, type)
          @media.concat(assess_media_importation(actual_folder, type, import_type_id==2, media_import.media_classification_1, media_import.media_classification_2, media_import.media_classification_3))
        end
      rescue Exception => exc
        flash[:notice] = "<b>Import failed</b>: #{exc.to_s}"
        redirect_to new_media_import_url
      else
        # render confirm
      end
    end
  end

  # POST /media_imports
  # POST /media_imports.xml
  def create
    import_type_id = params[:import_type_id].to_i
    media_separated = params[:media]
    media_file_name = media_separated[:file_name]
    case import_type_id
    when 1 # Add new media to db
      classifications = params[:classifications]
      media_type = media_separated[:type]
    when 2 # Update media files
      media_id = media_separated[:id]
    end
    media_integrated = Array.new
    0.upto(media_separated[:file_name].size-1) do |i|
      medium = { :file_name => media_file_name[i] }
      case import_type_id
      when 1 # Add new media to db
        medium[:type] = media_type[i]
        classification = [media_separated[:classification_0][i]]
        classification << media_separated[:classification_1][i] if !media_separated[:classification_1].nil?
        classification << media_separated[:classification_2][i] if !media_separated[:classification_2].nil?
        medium[:classification] = classification
      when 2 # Update media files
        medium[:id] = media_id[i]
      end 
      media_integrated << medium
    end
    case import_type_id
    when 1 # Add new media to db
      fork_media_importation(media_integrated, classifications)
      redirect_to status_media_imports_url
    when 2 # Update media files
      fork_media_update(media_integrated)
      redirect_to status_media_imports_url      
    end
  end
  
  private
  
  def get_folder_names(folder)
    folder_names = Array.new
    Dir.chdir(folder) { Dir.glob('[^.]*').sort.each{ |file_name| folder_names << file_name if File.directory?(file_name) } }
    return folder_names
  end
  
  def copy_folders(source_folder, destination_folder, subfolder)
    get_folder_names(File.join(source_folder, subfolder)).each { |folder| cp_r(File.join(source_folder, subfolder, folder), File.join(destination_folder, subfolder)) }
  end  
end