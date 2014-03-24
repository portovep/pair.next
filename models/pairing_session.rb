class PairingSession
  attr_accessor :pairs

  def initialize(pairs)
     @pairs = pairs
  end

  def ==(other_session)
    @pairs.to_set == other_session.pairs.to_set
  end

  def is_valid_for(team_members)
    pair_membership_counter = {}
    team_members.each { |member| pair_membership_counter[member] = 0 }
    @pairs.each { |pair| pair.each {|user| pair_membership_counter[user] += 1 }}

    valid_user_entries = pair_membership_counter.select { |k,v| v == 1}
   
    valid_user_entries.count == pair_membership_counter.count
  end
end