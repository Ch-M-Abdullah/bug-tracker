class BugAssignment < ApplicationRecord
  belongs_to :bug
  belongs_to :user
end
