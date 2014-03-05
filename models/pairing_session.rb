class PairingSession < ActiveRecord::Base
	has_many :pairing_memberships
end