class RenameProjectNameToName < ActiveRecord::Migration
  def change
    rename_column :teams, :project_name, :name
  end
end
