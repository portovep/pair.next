class User < ActiveRecord::Base
	has_many :team_members
	has_many :pairing_memberships
end