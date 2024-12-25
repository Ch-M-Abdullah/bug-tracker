class Bug < ApplicationRecord
  belongs_to :project
  has_one_attached :image

  has_many :bug_assignments
  has_many :users, through: :bug_assignments

  validates :name, uniqueness: { scope: :project_id } # Ensuring No Same Name Bug is Written in The Same Project
  validates :status, inclusion: { in: [ true, false ] } # Ensuring `status` can only be set to true/false
  validates :category, inclusion: { in: [ "bug", "feature" ] } # Ensuring `type` can only be set to 'bug'/'feature'
end
