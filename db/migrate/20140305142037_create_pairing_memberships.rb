class CreatePairingMemberships < ActiveRecord::Migration
	def change
		create_table :pairing_memberships do |t|
			t.integer :user_id
			t.integer :pairing_session_id

			t.timestamps
		end
	end
end
