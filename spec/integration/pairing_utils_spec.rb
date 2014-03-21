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
    PairingUtils.all_possible_pairs([@florian,@tom]).should match_array [[@florian,@tom]]
    PairingUtils.all_possible_pairs([@florian,@lukas,@pablo,@martino]).should match_array [
      [@florian, @lukas],[@lukas,@martino],[@lukas,@pablo],[@florian,@martino], [@florian,@pablo], [@pablo,@martino]]
  end

  it 'should include pairs with one user for a set of users woth odd number' do
    PairingUtils.all_possible_pairs([@florian,@tom,@martino]).should match_array [
      [@florian,@tom],[@florian,@martino],[@tom,@martino],[@florian],[@tom],[@martino]
    ]
  end

  it 'should detect an invalid pairing session if a user appears more than once' do
    PairingUtils.is_valid_pairing_session([[@florian,@tom],[@florian,@martino]],[@florian,@tom,@martino]).should be == false
  end

  it 'should detect a valid pairing session if no user appears more than once' do
    PairingUtils.is_valid_pairing_session([[@florian,@tom],[@pablo,@martino]],[@florian,@tom,@martino,@pablo]).should be == true
  end

  it 'should detect if a teammember is not part of the pairing session' do
    PairingUtils.is_valid_pairing_session([[@florian,@tom]],[@florian,@tom,@martino,@pablo]).should be == false
  end

  it 'should provide all possible pairing sessions' do
    PairingUtils.all_possible_pairing_sessions([@lukas,@florian,@pablo,@martino]).should match_array [
          [[@lukas, @florian],[@pablo,@martino]],
          [[@lukas, @martino],[@florian,@pablo]],
          [[@lukas, @pablo],[@florian,@martino]]]
  end

  it 'should provide all possible pairing sessions for odd number of team members' do
    PairingUtils.all_possible_pairing_sessions([@lukas,@florian,@pablo]).should match_array [
          [[@lukas, @florian],[@pablo]],
          [[@lukas, @pablo],[@florian]],
          [[@florian, @pablo],[@lukas]]]
  end

  it 'should count the number of pairings in a session' do
    PairingUtils.number_of_pairings_in_session([[@florian,@martino],[@tom,@pablo]],@mock_counter).should be == 3
    PairingUtils.number_of_pairings_in_session([[@lukas,@martino],[@tom,@pablo]],@mock_counter).should be == 2
  end

  it 'should count the number of pairings in a session when pairings contain a single user' do
    PairingUtils.number_of_pairings_in_session([[@lukas],[@tom,@pablo]],@mock_counter).should be == 3
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

    PairingUtils.find_best_sessions_for_team_members([@florian,@martino,@tom],@mock_counter).should match_array [good_session1,good_session2]
  end 

end

