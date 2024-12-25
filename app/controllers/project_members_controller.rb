class ProjectMembersController < ApplicationController
  before_action :set_project_member, only: [ :destroy ]

  def new
    @project_member = ProjectMember.new

    @projects = Project.all

    if params[:project_id].present?
      @selected_project = Project.find(params[:project_id])
      puts "Selected Project: #{@selected_project.name}"
    end

    @users = User.where(role: [ "developer", "qa" ]).select { |user| !user.projects.include?(@selected_project) }
  end

  def create
    @project_member = ProjectMember.new(project_member_params)

    begin
      respond_to do |format|
        if @project_member.save
          format.html { redirect_to projects_path, notice: "Member was successfully Saved." }
          format.json { render :show, status: :created, location: @project_member }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @project_member.errors, status: :unprocessable_entity }
        end
      end

    rescue
      redirect_to projects_path
    end
  end

  def destroy
    @project_member.destroy!

    respond_to do |format|
      format.html { redirect_to (request.referrer || projects_path), status: :see_other, notice: "Project Member was successfully removed." }
      format.json { head :no_content }
    end
  end


  private
    def set_project_member
      @project_member = ProjectMember.find_by(user_id: params.expect(:id))
    end

    def project_member_params
      params.expect(project_member: [ :user_id, :project_id ])
    end
end
