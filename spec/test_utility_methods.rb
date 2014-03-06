class TestUtilityMethods
	def initialize()
	end

	def self.create_pair(name_one, name_two)
	  pair = PairingSession.create()
      PairingMembership.create(user: User.find_by_username(name_one), pairing_session: pair)
      PairingMembership.create(user: User.find_by_username(name_two), pairing_session: pair)
	end
end