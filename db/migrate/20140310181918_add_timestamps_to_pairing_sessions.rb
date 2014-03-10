class AddTimestampsToPairingSessions < ActiveRecord::Migration
  def change
    add_timestamps :pairing_sessions
  end
end
