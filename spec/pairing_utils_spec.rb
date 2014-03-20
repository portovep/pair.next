require_relative './test_helper.rb'

describe 'Team class' do
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
end