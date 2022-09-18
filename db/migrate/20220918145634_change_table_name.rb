class ChangeTableName < ActiveRecord::Migration[5.2]
  def change
    rename_table :ingredients_tables, :ingredients
  end
end
