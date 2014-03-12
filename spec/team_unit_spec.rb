require_relative './test_helper.rb'

describe 'Team class' do


	before(:each) do
    @team = Team.create(name: 'team_test')
    
    @new_teammembers = ["Lukas", "Florian", "Pablo", "Martino"]

    @new_teammembers.each do |member|
    	new_member = User.create(username: member)
    	team_membership = TeamMember.create(user: new_member, team: @team)
    end
    
    @lukas = User.find_by_username("Lukas")
    @florian = User.find_by_username("Florian")
    @pablo = User.find_by_username("Pablo")
    @martino = User.find_by_username("Martino")
  end

	it 'should get the most current old pairs' do
    start_time = Time.now
    end_time = start_time + (10*60)
    TestUtilityMethods.create_pair("Pablo", "Florian", start_time, end_time)
    TestUtilityMethods.create_pair("Lukas", "Martino", start_time, end_time)

    TestUtilityMethods.create_pair("Lukas", "Florian", end_time)
    TestUtilityMethods.create_pair("Pablo", "Martino", end_time)

		old_pairs = @team.get_current_pairs
		old_pairs.should be == [[User.find_by_username("Lukas"), User.find_by_username("Florian")],
								[User.find_by_username("Pablo"), User.find_by_username("Martino")]]
	end

  it 'should return empty array when no pairings exist' do
    old_pairs = @team.get_current_pairs
    old_pairs.should be == []
  end

  it 'should shuffle pairs when no previous pairings exist' do 
    new_pairs = @team.shuffle_pairs
    new_pairs.size.should be == 2
    new_pairs[0].size.should be == 2
    new_pairs[1].size.should be == 2
  end 

  it 'should output all possible pairings' do 
    possible_pairings = @team.all_possible_pairs
    expected_pairings = [[@lukas, @florian],[@lukas,@martino],[@lukas,@pablo],[@florian,@martino], [@florian,@pablo], [@pablo,@martino]]

    possible_pairings.should match_array expected_pairings
  end

  it 'should output all possible pairing sessions' do 
    possible_sessions = @team.all_possible_pairing_sessions
    expected_sessions = [
          [[@lukas, @florian],[@pablo,@martino]],
          [[@lukas, @martino],[@florian,@pablo]],
          [[@lukas, @pablo],[@florian,@martino]],
                            ]

    possible_sessions.should match_array expected_sessions
  end

  it 'should generate only possible pairing solution left' do
    start_time = Time.now
    end_time = start_time + (10*60)
    TestUtilityMethods.create_pair("Pablo", "Florian", start_time, end_time)
    TestUtilityMethods.create_pair("Lukas", "Martino", start_time, end_time)

    TestUtilityMethods.create_pair("Lukas", "Florian", end_time)
    TestUtilityMethods.create_pair("Pablo", "Martino", end_time)

    new_pairs = @team.shuffle_pairs
    new_pairs.should be == [[User.find_by_username("Lukas"), User.find_by_username("Pablo")],
                            [User.find_by_username("Florian"), User.find_by_username("Martino")]]
  end

  it 'should generate a valid pairing solution when more than one option exists' do 
    TestUtilityMethods.create_pair("Lukas", "Florian")
    TestUtilityMethods.create_pair("Pablo", "Martino")

    # valid pairing check: 
    new_pairs = @team.shuffle_pairs

    new_pairs.count.should be == 2
    pair_membership_counter = {@florian => 0, @lukas=> 0, @martino=>0, @pablo=>0}
    new_pairs.each { |pair| pair.each {|user| pair_membership_counter[user] += 1 }}

    pair_membership_counter.each { |k,v| v.should be == 1}
    # todo: the checks are also in Team#isValidPairingSession
    # todo: better checks?
  end

  it 'should generate a hash of pairings grouped by start date as pairing history' do 
    today = Time.current.utc.change(usec:0)
    yesterday = today - (24*60*60)
    
    TestUtilityMethods.create_pair("Pablo", "Florian", yesterday, today)
    TestUtilityMethods.create_pair("Lukas", "Martino", yesterday, today)

    TestUtilityMethods.create_pair("Lukas", "Florian", today)
    TestUtilityMethods.create_pair("Pablo", "Martino", today)

    expected = {
      yesterday => [[@pablo,@florian],[@lukas,@martino]],
      today => [[@lukas,@florian],[@pablo,@martino]]
    }

    @team.pairing_history.should be == expected
  end

  it 'should generate pairing statistics' do 
    today = Time.now
    yesterday = today - (24*60*60)
    dayBefore = yesterday - (24*60*60)
    PairingSession.create(users: [@martino,@pablo], start_time: dayBefore, end_time: yesterday)
    PairingSession.create(users: [@lukas,@florian], start_time: dayBefore, end_time: yesterday)

    PairingSession.create(users: [@martino,@pablo], start_time: yesterday, end_time: today) 

    @team.pairing_statistics.should be == {
      [@pablo,@martino] => 2,
      [@lukas,@florian] => 1,
      [@lukas,@martino] => 0, 
      [@lukas,@pablo] => 0, 
      [@florian,@martino] => 0, 
      [@florian,@pablo] => 0
    }
  end


end
