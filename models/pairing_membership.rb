class PairingMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :pairing_session
end
