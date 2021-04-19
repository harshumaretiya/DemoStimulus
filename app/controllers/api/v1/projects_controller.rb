class Api::V1::ProjectsController < Api::V1::AuthenticatedController
  before_action :set_project only: [:update, :destroy, :show]


  # GET  /api/v1/projects
  def index
    begin
      authorize! :index, @current_user
      projects = @current_owner.
                projects.
                order('created_at DESC').
                paginate(page: params[:page], per_page: 10) 
    rescue => e 
      render_exception(e, 422) && return
    end
    json_response(ProjectSerializer.new(projects).serializable_hash[:data].map {|project| project[:attributes]},MetaGenerator.new.generate!(projects))
  end

  #POST /api/v1/projects
  def create
    begin
      authorize! :create, @current_user
      project = @current_owner.projects.create!(project_params)
    rescue => e 
      render_exception(e, 422) && return
    end
    json_response(ProjectSerializer.new(project).serializable_hash[:data][:attributes])
  end

  #PUT /api/v1/projects/:id
  def update
    begin
      authorize! :update, @current_user
      @project.update!(project_params)  
    rescue => e 
      render_exception(e, 422) && return
    end
    json_response(ProjectSerializer.new(@project).serializable_hash[:data][:attributes])
  end

  #GET /api/v1/projects/:id
  def show
    begin
      authorize! :show, @current_user
    rescue => e 
      render_exception(e, 422) && return
    end
    json_response(ProjectSerializer.new(@project).serializable_hash[:data][:attributes])
  end

  #DELETE /api/v1/projects/:id
  def destroy
    begin
      authorize! :destroy, @current_user
      @project.destroy
    rescue => e 
      render_exception(e, 422) && return
    end
    render json: { success: true, data: {}, errors: [] }, status: 200
  end

  #private methods
  private

  def project_params
    params.require(:project).permit(:name, :description)
  end
  
  def set_project
    @project = Project.find(params[:id])
  end
end 
