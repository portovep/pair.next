class AddTeamIdToParings < ActiveRecord::Migration
  def change
 		add_column :pairings, :team_id, :integer
  end
end
