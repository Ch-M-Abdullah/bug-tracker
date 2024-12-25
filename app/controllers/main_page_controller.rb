class MainPageController < ApplicationController
  def index
    if !user_signed_in?
      redirect_to new_user_session_path
    elsif current_user.role == "admin"
      redirect_to projects_path
    elsif current_user.role == "qa"
      redirect_to projects_path
    elsif current_user.role == "developer"
      redirect_to bugs_path
    end
  end
end
