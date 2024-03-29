class PairingSession
  attr_accessor :pairs

  def self.from_array(pairs)
    PairingSession.new(pairs.map { |pair| Pair.new(pair) })
  end

  def initialize(pairs)
    @pairs = pairs
  end

  def ==(other_session)
    @pairs.to_set == other_session.pairs.to_set
  end

  alias eql? ==

  def hash
    @pairs.to_set.hash
  end

  def is_valid_for(team_members)
    pair_membership_counter = {}

    team_members.each { |member| pair_membership_counter[member] = 0 }
    @pairs.each { |pair| pair.members.each { |user| pair_membership_counter[user] += 1 } }

    valid_user_entries = pair_membership_counter.select { |k, v| v == 1 }

    valid_user_entries.count == pair_membership_counter.count
  end


  def number_of_pairings_in_session(count_for_users)
    pairs.map { |pair| count_for_users.call(pair.members[0], pair.members[1]) }.reduce(0, :+)
  end

  def inspect
    "PairingSession #{pairs}"
  end
end