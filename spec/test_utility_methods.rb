class TestUtilityMethods
	def initialize()
	end

	def self.create_pair(name_one, name_two, start_time = nil, end_time = nil)
	  pair = PairingSession.create(start_time: start_time, end_time: end_time)
      PairingMembership.create(user: User.find_by_username(name_one), pairing_session: pair)
      PairingMembership.create(user: User.find_by_username(name_two), pairing_session: pair)
	end
end