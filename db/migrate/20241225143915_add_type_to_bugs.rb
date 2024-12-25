class AddTypeToBugs < ActiveRecord::Migration[8.0]
  def change
    add_column :bugs, :type, :string, null: false, default: "bug"
    # Ex:- :default =>''
  end
end
