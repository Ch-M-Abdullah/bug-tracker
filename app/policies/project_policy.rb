class ProjectPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    user.role == "admin"
  end

  def create?
    user.role == "admin"
  end

  def edit?
    user.role == "admin"
  end

  def update?
    user.role == "admin"
  end

  def destroy?
    user.role == "admin"
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.role == "admin" || user.role == "qa"
        scope.all
      else # If user is `developer`
        # scope.where(user_id: current_user.id)
        # scope.all.select { |project| project.users.include?(user) }
        scope.joins(:users).where(users: { id: user.id })
      end
    end
  end
end
