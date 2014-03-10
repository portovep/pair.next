class CreatePairingSessions < ActiveRecord::Migration
  def change
    create_table :pairing_sessions do |t|
      t.string :members, array: true, default: '{}'
    end

    add_index :pairing_sessions, :members, using: 'gin'
  end
end
