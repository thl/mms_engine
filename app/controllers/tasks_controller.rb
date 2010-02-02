class TasksController < AclController
  def initialize
    super
    @guest_perms = []
  end
  
  # GET /tasks
  # GET /tasks.xml
  def index
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = params[:task]
    redirect_to new_task_url if @task.blank?
    @response = `#{@task}`
  end
  
  def file
  end
  
  def create_file
    filename = params[:filename]
    contents = params[:contents]
    redirect_to file_new_path if filename.blank? || contents.blank?
    File.open(File.expand_path(File.join(RAILS_ROOT, filename)), "w") { |file| file.write(contents) }
    flash[:notice] = 'File has been over-written.'
    redirect_to tasks_path
  end
end
