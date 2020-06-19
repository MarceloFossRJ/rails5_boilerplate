class WorkspacesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workspace, only: [:show, :edit, :update, :destroy]

  def index
    @q = Workspace.ransack(params[:q])
    @q.sorts = 'begin_date desc' if @q.sorts.empty?
    @workspaces = @q.result(distinct: true).page params[:page]
    authorize @workspaces
  end

  def show
  end

  def new
    @workspace = Workspace.new
    authorize @workspace
  end

  def edit
  end

  def create
    @workspace = Workspace.new(workspace_params)
    authorize @workspace
    member_params = Hash.new
    member_params[:owner_id] = current_user.id
    @workspace.default_currencies = helpers.save_multiselect(params[:workspace][:default_currencies])
    @workspace.create_with_transaction(member_params)
    respond_to do |format|
      if @workspace.persisted?
        format.html { redirect_to workspaces_path, notice: 'Workspace was successfully created.' }
        format.json { render :show, status: :created, location: @workspace }
      else
        format.html { render :new }
        format.json { render json: @workspace.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @workspace.default_currencies = helpers.save_multiselect(params[:workspace][:default_currencies])
    respond_to do |format|
      if @workspace.update(workspace_params)
        format.html { redirect_to edit_workspace_path(@workspace), notice: 'Workspace was successfully updated.' }
        format.json { render :show, status: :ok, location: @workspace }
      else
        format.html { render :edit }
        format.json { render json: @workspace.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @workspace.destroy
    respond_to do |format|
      format.html { redirect_to workspaces_url, notice: 'Workscpace was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_workspace
    @workspace = Workspace.find(params[:id])
    authorize @workspace
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def workspace_params
    params.require(:workspace).permit(:subdomain,
                                    :name,
                                    :is_multiuser,
                                    :logo,
                                    :logo_cache,
                                    :default_currencies,
                                    :user_can_self_exclude,
                                    :user_can_invite,
                                    :remove_logo)
  end

  def sort_column
    Workspace.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
