class BugsController < ApplicationController
  before_action :set_bug, only: %i[ show edit update destroy mark_done assign_user ]
  before_action :authenticate_user!

  # GET /bugs or /bugs.json
  def index
    if params[:search].present? && params[:search] != ""
      @bugs = policy_scope(Bug.where("name LIKE ?", "%#{params[:search]}%"))
    else
      @bugs = policy_scope(Bug.all)
    end
  end

  # GET /bugs/1 or /bugs/1.json
  def show
    @assigned_users = @bug.users.select { |user| user.role == "developer" }
  end

  # GET /bugs/new
  def new
    @bug = Bug.new
    @projects = current_user.projects
    authorize @bug
  end

  # GET /bugs/1/edit
  def edit
    @projects = current_user.projects
    authorize @bug
  end

  # POST /bugs or /bugs.json
  def create
    @bug = Bug.new(bug_params)
    authorize @bug

    begin
      respond_to do |format|
        if @bug.save
          format.html { redirect_to @bug, notice: "Bug was successfully created." }
          format.json { render :show, status: :created, location: @bug }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @bug.errors, status: :unprocessable_entity }
        end
      end

    rescue StandardError
        redirect_to request.referrer || bugs_path, notice: "Bug Already Exists"
    end
  end

  # PATCH/PUT /bugs/1 or /bugs/1.json
  def update
    authorize @bug

    respond_to do |format|
      if @bug.update(bug_params)
        format.html { redirect_to @bug, notice: "Bug was successfully updated." }
        format.json { render :show, status: :ok, location: @bug }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bug.errors, status: :unprocessable_entity }
      end
    end
  end

  def mark_done
    @bug.users.each { |user| EmailerJob.perform_async(user.id, @bug.id) }
    @bug.update(status: true)
    redirect_to bugs_path
  end

  def assign_user
    if !@bug.users.include?(current_user)
      @bug.users << current_user
      redirect_to request.referrer || bugs_path
    else
      redirect_to bugs_path, notice: "User Already Assigned"
    end
  end

  # DELETE /bugs/1 or /bugs/1.json
  def destroy
    authorize @bug
    BugAssignment.where(bug_id: @bug.id).delete_all
    @bug.destroy!

    respond_to do |format|
      format.html { redirect_to bugs_path, status: :see_other, notice: "Bug was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bug
      @bug = Bug.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def bug_params
      params.require(:bug).permit(:id, :name, :description, :category, :project_id, :image)
    end
end
