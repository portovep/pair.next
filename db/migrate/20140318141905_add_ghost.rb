class AddGhost < ActiveRecord::Migration
  class User < ActiveRecord::Base
    def change
  	  User.create(username:"Balthasar")
  	end
  end
end
