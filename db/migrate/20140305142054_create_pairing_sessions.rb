class CreatePairingSessions < ActiveRecord::Migration
	def change
		create_table :pairing_sessions do |t|
			t.string :story_number
			t.timestamp :start_time
			t.timestamp :end_time

			t.timestamps
		end
	end
end
