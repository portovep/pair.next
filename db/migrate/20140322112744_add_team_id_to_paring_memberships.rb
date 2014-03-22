class AddTeamIdToParingMemberships < ActiveRecord::Migration
  def change
  	 add_column :pairing_memberships, :team_id, :int
  end
end
