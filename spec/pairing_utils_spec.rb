require_relative './test_helper.rb'

describe 'PairingUtils' do
  before(:each) do
    @florian = { username: "florian"}
    @martino = { username: "martino"}
    @pablo = { username: "pablo"}
    @tom = { username: "tom"}
    @lukas = { username: "lukas"}

  end

  it 'should provide all possible pairs for a set of users' do
    PairingUtils.all_possible_pairs([@florian,@tom]).should match_array [[@florian,@tom]]
    PairingUtils.all_possible_pairs([@florian,@lukas,@pablo,@martino]).should match_array [
      [@florian, @lukas],[@lukas,@martino],[@lukas,@pablo],[@florian,@martino], [@florian,@pablo], [@pablo,@martino]]
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

  it 'should count the number of pairings in a session' do 
    mock_counter = proc do |user1,user2|
      (user1 == @florian && user2 == @martino) ? 2 : 1 
    end

    PairingUtils.number_of_pairings_in_session([[@florian,@martino],[@tom,@pablo]],mock_counter).should be == 3
    PairingUtils.number_of_pairings_in_session([[@lukas,@martino],[@tom,@pablo]],mock_counter).should be == 2
  end
end