require_relative '../test_helper.rb'

describe Pair do
  before(:each) do
    @florian = { username: "florian"}
    @martino = { username: "martino"}
    @pablo = { username: "pablo"}
    @tom = { username: "tom"}
    @lukas = { username: "lukas"}
  end
  
  it 'should represent a set of users independent of order' do
    pair = Pair.new([@florian,@martino])
    pair2 = Pair.new([@martino,@florian])

    pair2.should be == pair
  end

  it 'should have an array-accessor' do 
    pair = Pair.new([@florian,@martino])
    pair.members.should be == [@florian,@martino]
  end
end