class Pair
  attr_accessor :members

  def initialize(members)
     @members = members
  end

  def ==(other_pair)
    @members.to_set == other_pair.members.to_set
  end
end