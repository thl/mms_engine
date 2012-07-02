class WorkflowsController < AclController
  helper :media
  before_filter :find_medium
  caches_page :show, :if => :api_response?.to_proc
  cache_sweeper :workflow_sweeper, :only => [:update, :destroy]
  
  def initialize
    super
    @guest_perms = []
  end

  # GET /workflows/1
  # GET /workflows/1.xml
  def show
    if !@medium.nil?
      @workflow = @medium.workflow
      @statuses = Status.order('position')
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @workflow }
      end
    end
  end

  # GET /workflows/new
  # GET /workflows/new.xml
  def new
    redirect_to media_url
  end

  # GET /workflows/1/edit
  def edit
    if !@medium.nil?
      @workflow = @medium.workflow
      @workflow = @medium.create_workflow if @workflow.nil?
    end  
  end

  # POST /workflows
  # POST /workflows.xml
  def create
    if !@medium.nil?
      @workflow = @medium.build_workflow(params[:workflow])
      respond_to do |format|
        if @workflow.save
          format.xml  { render :xml => @workflow, :status => :created, :location => medium_workflow_url(@medium) }
        else
          format.xml  { render :xml => @workflow.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /workflows/1
  # PUT /workflows/1.xml
  def update
    if !@medium.nil?
      @workflow = @medium.workflow
      respond_to do |format|
        if @workflow.update_attributes(params[:workflow])
          flash[:notice] = ts('edit.successful', :what => Workflow.human_name.capitalize)
          format.html { redirect_to edit_medium_path(@medium, :anchor => 'workflow') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @workflow.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /workflows/1
  # DELETE /workflows/1.xml
  def destroy
    if !@medium.nil?
      @workflow = @medium.workflow
      @workflow.destroy
      respond_to do |format|
        format.html { redirect_to media_url }
        format.xml  { head :ok }
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
  
  def api_response?
    request.format.xml?
  end
end