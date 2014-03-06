class PairingSession < ActiveRecord::Base
  has_many :pairing_memberships
  has_many :users, through: :pairing_memberships
end
