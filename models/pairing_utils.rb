class PairingUtils
  def self.all_possible_pairs(team_members)
    team_members.combination(2).to_a
  end

  def self.is_valid_pairing_session(session,team_members)
    pair_membership_counter = {}
    team_members.each { |member| pair_membership_counter[member] = 0 }
    session.each { |pair| pair.each {|user| pair_membership_counter[user] += 1 }}

    valid_user_entries = pair_membership_counter.select { |k,v| v == 1}
   
    valid_user_entries.count == pair_membership_counter.count
  end

 def self.all_possible_pairing_sessions(team_members)
    combinations = all_possible_pairs(team_members).combination(team_members.count/2)
    valid_combinations = combinations.select { |session| is_valid_pairing_session(session,team_members) }

    valid_combinations
 end

 def self.number_of_pairings_in_session(session,count_for_users)
    session.map {|pair| count_for_users.call(pair[0],pair[1])}.reduce(0,:+)
 end
  
end