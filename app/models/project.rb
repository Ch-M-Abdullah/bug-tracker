class Project < ApplicationRecord
  has_many :project_members
  has_many :users, through: :project_members
  has_many :bugs

  validates :name, uniqueness: { case_sensitive: false }
end
