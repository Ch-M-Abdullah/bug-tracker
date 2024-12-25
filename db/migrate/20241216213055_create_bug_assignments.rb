class CreateBugAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :bug_assignments do |t|
      t.references :bug, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
