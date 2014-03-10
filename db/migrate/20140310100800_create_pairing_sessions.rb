class CreatePairingSessions < ActiveRecord::Migration
  def change
    create_table :pairing_sessions do |t|
      t.string :user_ids, array: true, default: '{}'
    end

    add_index :pairing_sessions, :user_ids, using: 'gin'
  end
end
