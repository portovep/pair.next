class AddUserBio < ActiveRecord::Migration
  def change
  	  	add_column :users, :bio, :string, :default => "Share a little about yourself."
  end
end
