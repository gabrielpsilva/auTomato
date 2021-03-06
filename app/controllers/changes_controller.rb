class ChangesController < ApplicationController
  before_action :set_change, only: [:show, :edit, :update, :destroy]
  #before_action :process_owner, only: [:create]

  autocomplete :project, :name, :full => true

  # GET /changes
  # GET /changes.json
  def index
    @changes = Change.all
  end

  # GET /changes/1
  # GET /changes/1.json
  def show
    @steps = @change.steps.reorder('stepNo ASC').includes(:assignedTo)
    @step = Step.new
    @step.id = (Step.last.id) +1
    @colors = StepStatus.all

    @change.links_to_display = %i(more_info add_step_modal edit_change_to clone_change_to update_change_status)

  end

  # GET /changes/new
  def new

    @change = Change.new
    @change.links_to_display = %i(clone_change_from)
  end

  # GET /changes/1/edit
  def edit

    @change.links_to_display = %i(more_info add_step_modal edit_change_to clone_change_to update_change_status)
  end

  # POST /changes
  # POST /changes.json
  def create
    @change = Change.new(change_params)
    @change.owner = process_owner
    @change.project = process_project
    @change.links_to_display = %i(clone_change_from)


    respond_to do |format|
      if @change.save
        format.html { redirect_to @change, notice: 'Change was successfully created.' }
        format.json { render :show, status: :created, location: @change }
      else
        format.html { render :new }
        format.json { render json: @change.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /changes/1
  # PATCH/PUT /changes/1.json
  def update
    respond_to do |format|
      if @change.update(change_params)
        format.html { redirect_to @change, notice: 'Change was successfully updated.' }
        format.json { render :show, status: :ok, location: @change }
      else
        format.html { render :edit }
        format.json { render json: @change.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /changes/1
  # DELETE /changes/1.json
  def destroy
    @change.destroy

    recount_steps


    respond_to do |format|
      format.html { redirect_to changes_url, notice: 'Change was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def project_autocomplete
    @projects = Project.order(:name).where("name LIKE ?", "%#{params[:term]}%")
    respond_to do |format|
      format.html
      format.json {
        render json: @projects.map(&:name).to_json
      }
    end
  end

  def owner_autocomplete
    @users = User.order(:name).where("name LIKE ?", "%#{params[:term]}%")
    respond_to do |format|
      format.html
      format.json {
        render json: @users.map(&:name).to_json
      }
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_change
    @change = Change.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def change_params
    params.require(:change).permit(:name, :description, :implementation_date, :owner, :project)
  end

  def process_owner
    @change.owner = User.find_by_name(params[:change][:owner_attributes][:name]) #unless @change.owner.id == params[:change][:owner_attributes][:id].to_i
  end

  def process_project
    @change.project = Project.find_by_name(params[:change][:project_attributes][:name]) #unless @change.owner.id == params[:change][:owner_attributes][:id].to_i
  end


end
