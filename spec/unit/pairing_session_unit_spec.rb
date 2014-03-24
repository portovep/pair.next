require_relative '../test_helper.rb'

describe PairingSession do
  before(:each) do
    @florian = { username: "florian"}
    @martino = { username: "martino"}
    @pablo = { username: "pablo"}
    @tom = { username: "tom"}
    @lukas = { username: "lukas"}

    @florian_martino = Pair.new([@florian,@martino])
    @lukas_tom = Pair.new([@lukas,@tom])
  end
  
  it 'should represent a set of pairs independent of order' do
    session1 = PairingSession.new([@florian_martino,@lukas_tom])
    session2 = PairingSession.new([@lukas_tom,@florian_martino])

    session1.should be == session2
  end

  it 'should have an array-accessor' do 
    # TODO: is this necessary?
    session1 = PairingSession.new([@florian_martino,@lukas_tom])
    session1.pairs.should be == [@florian_martino,@lukas_tom]
  end

  it 'should detect an invalid pairing session if a user appears more than once' do
    PairingSession.new([Pair.new([@florian,@tom]),Pair.new([@florian,@martino])]).is_valid_for([@florian,@tom,@martino]).should be == false
  end

  it 'should detect a valid pairing session if no user appears more than once' do
    PairingSession.new([Pair.new([@florian,@tom]),Pair.new([@pablo,@martino])]).is_valid_for([@florian,@tom,@martino,@pablo]).should be == true
  end

  it 'should detect if a teammember is not part of the pairing session' do
    PairingSession.new([Pair.new([@florian,@tom])]).is_valid_for([@florian,@tom,@martino,@pablo]).should be == false
  end

end