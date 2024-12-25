class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :project_members
  has_many :projects, through: :project_members

  has_many :bug_assignments
  has_many :bugs, through: :bug_assignments

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  ROLES = [ "admin", "qa", "developer" ]
  validates :role, inclusion: { in: ROLES } # This is to validate that the `role` column only contains "admin", "qa" or "developer"
end
