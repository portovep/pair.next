class TestUtilityMethods
	def initialize
	end

	def self.create_pair(name_one, name_two, start_time = nil, end_time = nil)
	  pairing_session = PairingSession.create(start_time: start_time, end_time: end_time)
	  pairing_session.users << User.find_by_username(name_one)
	  pairing_session.users << User.find_by_username(name_two)
	  pairing_session.save
	end

end