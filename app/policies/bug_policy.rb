class BugPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    user.role == "qa"
  end

  def edit?
    user.role == "qa" || user.role == "developer"
  end

  def create?
    user.role == "qa"
  end

  def update?
    user.role == "qa" || user.role == "developer"
  end

  def destroy?
    user.role == "qa"
  end



  class Scope < ApplicationPolicy::Scope
      # NOTE: Be explicit about which records you allow access to!
      def resolve
        if user.role == "admin" || user.role == "qa"
          scope.all
        else # For Developers
          # scope.all.select { |bug| bug.project.users.include?(user) }
          scope.joins(project: :users).where(users: { id: user.id })

        end
      end
  end
end
