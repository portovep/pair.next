class Pair 
  attr_accessor :members

  def initialize(members)
     @members = members
  end

  def ==(other_pair)
    @members.to_set == other_pair.members.to_set
  end

  alias eql? ==


  def inspect
    "Pair #{members}"
  end

  def hash 
    members.to_set.hash
  end
end