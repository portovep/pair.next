class RenamePairingSessionId < ActiveRecord::Migration
  def change
        rename_column :pairing_memberships, :pairing_session_id, :pairing_id
  end
end
