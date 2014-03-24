class RenamePairingSessionsIntoPairings < ActiveRecord::Migration
  def change
    rename_table :pairing_sessions, :pairings
  end
end
