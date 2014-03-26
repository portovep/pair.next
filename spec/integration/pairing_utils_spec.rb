require_relative '../test_helper.rb'

describe PairingUtils do
  before(:each) do
    @florian = { username: "florian"}
    @martino = { username: "martino"}
    @pablo = { username: "pablo"}
    @tom = { username: "tom"}
    @lukas = { username: "lukas"}

    @mock_counter = proc do |user1,user2|
      ((user1 == @florian && user2 == @martino)||(user2 == nil)) ? 2 : 1
    end
  end

  it 'should provide all possible pairs for a set of users with even number' do
    PairingUtils.all_possible_pairs([@florian,@tom]).should match_array [Pair.new([@florian,@tom])]
    PairingUtils.all_possible_pairs([@florian,@lukas,@pablo,@martino]).should match_array [
      Pair.new([@florian, @lukas]),
      Pair.new([@lukas,@martino]),
      Pair.new([@lukas,@pablo]),
      Pair.new([@florian,@martino]),
      Pair.new([@florian,@pablo]), 
      Pair.new([@pablo,@martino])]
  end

  it 'should include pairs with one user for a set of users woth odd number' do
    PairingUtils.all_possible_pairs([@florian,@tom,@martino]).should match_array [
      Pair.new([@florian,@tom]),
      Pair.new([@florian,@martino]),
      Pair.new([@tom,@martino]),
      Pair.new([@florian]),
      Pair.new([@tom]),
      Pair.new([@martino])
    ]
  end

  it 'should provide all possible pairing sessions' do
    PairingUtils.all_possible_pairing_sessions([@lukas,@florian,@pablo,@martino]).should match_array [
          PairingSession.new([Pair.new([@lukas, @florian]),Pair.new([@pablo,@martino])]),
          PairingSession.new([Pair.new([@lukas, @martino]),Pair.new([@florian,@pablo])]),
          PairingSession.new([Pair.new([@lukas, @pablo]),Pair.new([@florian,@martino])])]
  end

  it 'should provide all possible pairing sessions for odd number of team members' do
    PairingUtils.all_possible_pairing_sessions([@lukas,@florian,@pablo]).should match_array [
          PairingSession.new([Pair.new([@lukas, @florian]),Pair.new([@pablo])]),
          PairingSession.new([Pair.new([@lukas, @pablo]),Pair.new([@florian])]),
          PairingSession.new([Pair.new([@florian, @pablo]),Pair.new([@lukas])])]
  end

  it 'should find the best session in a set of possible session' do
    bad_session = [[@florian,@martino],[@lukas,@tom]]
    good_session1 = [[@lukas,@martino],[@florian,@tom]]
    good_session2 = [[@tom,@martino],[@lukas,@florian]]

    possible_sessions = [bad_session,good_session2,good_session1]

    PairingUtils.find_best_sessions(possible_sessions,@mock_counter).should match_array [good_session2,good_session1]
  end

  it 'should find the best session when session includes pairings with a single user' do
    bad_session = [[@florian,@martino],[@lukas]]
    good_session = [[@lukas,@martino],[@tom]]

    possible_sessions = [bad_session,good_session]

    PairingUtils.find_best_sessions(possible_sessions,@mock_counter).should match_array [good_session]
  end
  it 'should find the best sessions for team members (integration)' do 
    good_session1 = [[@martino,@tom],[@florian]]
    good_session2 = [[@florian,@tom],[@martino]]

    to_exclude = PairingSession.from_array(good_session2)
    PairingUtils.find_best_sessions_for_team_members([@florian,@martino,@tom],to_exclude,@mock_counter).should match_array [good_session1]
  end

  it 'should filter sessions' do 
    session_1 = PairingSession.from_array([[@martino,@tom],[@florian]])
    session_2 = PairingSession.from_array([[@florian,@tom],[@martino]])
    session_2_with_reversed_pair = PairingSession.from_array([[@tom,@florian],[@martino]])
    PairingUtils.filter_from_sessions_if_appropriate([session_1,session_2],session_2).should match_array [session_1]
    PairingUtils.filter_from_sessions_if_appropriate([session_1,session_2],session_2_with_reversed_pair).should match_array [session_1]
  end 

  it 'should not filter sessions if this would result in an empty result' do 
    session_1 = PairingSession.from_array([[@martino,@tom],[@florian]])
    PairingUtils.filter_from_sessions_if_appropriate([session_1],session_1).should match_array [session_1]
  end 

  it 'filter from session should work for strange edge cases (regression tests)' do 
    all_possible_pairing_sessions = PairingUtils.all_possible_pairing_sessions([@florian,@martino,@tom])
    PairingUtils.filter_from_sessions_if_appropriate(all_possible_pairing_sessions,PairingSession.from_array([[@florian,@tom],[@martino]])).count.should be > 0
    PairingUtils.filter_from_sessions_if_appropriate(all_possible_pairing_sessions,PairingSession.from_array([])).count.should be > 0
  end

end
