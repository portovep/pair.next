class User < ActiveRecord::Base
end
class AddAGhostUser < ActiveRecord::Migration
  def change
	  User.create(username:"Balthasar",nickname:"The pairing ghost")
  end
end
