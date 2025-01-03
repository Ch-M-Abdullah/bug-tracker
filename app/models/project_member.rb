class ProjectMember < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :user_id, uniqueness: { scope: :project_id } # Ensuring That No Duplicate Values are Entered
end
