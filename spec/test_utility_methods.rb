class TestUtilityMethods

  def self.create_pair(name_one, name_two, start_time = nil, end_time = nil)
    pairing = Pairing.create(start_time: start_time, end_time: end_time)
    user = User.find_by_username(name_one)
    user.nickname = user.username[/[^@]+/]
    pairing.users << user
    user = User.find_by_username(name_two)
    user.nickname = user.username[/[^@]+/]
    pairing.users << user
    pairing.save
  end

end
