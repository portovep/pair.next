class AddTeamIdToPairingSession < ActiveRecord::Migration
  def change
    add_column :pairing_sessions, :team_id, :integer
  end
end
