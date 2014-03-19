class User < ActiveRecord::Base
end
class AddGhost < ActiveRecord::Migration

  def change
	  User.create(username:"Balthasar")
	end
end
