class ChangeColumnName < ActiveRecord::Migration[8.0]
  def change
    rename_column :bugs, :type, :category
  end
end
