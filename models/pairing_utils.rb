class PairingUtils
  def self.all_possible_pairs(team_members)
    possible_pairs = team_members.combination(2).to_a
    if (team_members.count % 2 == 1)
      pairs_with_single_user = team_members.map{|member| [member]}
      possible_pairs.concat(pairs_with_single_user)
    end
    possible_pairs.map { |pair| Pair.new(pair)}
  end

 def self.all_possible_pairing_sessions(team_members)
    if team_members.count%2 == 0 
      number_of_pairs = team_members.count/2
    else 
      number_of_pairs = team_members.count/2+1
    end

    combinations = all_possible_pairs(team_members).combination(number_of_pairs).map {|session| PairingSession.new(session)}
    valid_combinations = combinations.select { |session| session.is_valid_for(team_members) }

    valid_combinations
 end

 def self.number_of_pairings_in_session(session,count_for_users)
    session.map {|pair| count_for_users.call(pair[0],pair[1])}.reduce(0,:+)
 end

 def self.find_best_sessions(sessions,count_for_users)
  pairing_number_map = sessions.map { |session| [session,number_of_pairings_in_session(session,count_for_users)]}
  minimum_pairing_number = pairing_number_map.min_by { |session,pairing_number| pairing_number}[1]

  pairing_number_map.select { |session,pairing_number| pairing_number == minimum_pairing_number }.map {|session,pairing_number| session}
 end

 def self.find_best_sessions_for_team_members(team_members,to_exclude,count_for_users) 
  all_possible_pairing_sessions = all_possible_pairing_sessions(team_members).map{|session| session.pairs }.map {|pairs| pairs.map { |pair| pair.members }}
  all_possible_pairing_sessions = filter_from_sessions_if_appropriate(all_possible_pairing_sessions,to_exclude)

  best_sessions = PairingUtils.find_best_sessions(all_possible_pairing_sessions,count_for_users)

  best_sessions    
 end

 # TODO: the following is connected and looks kind of strange: 
 # filter_from_sessions_if_appropriate,contains_pair,is_same_pair
 def self.filter_from_sessions_if_appropriate(sessions,to_exclude) 
  if (sessions.count > 1) 
    sessions.select do |session|
      session.count != to_exclude.count || !to_exclude.map { |pair_to_exclude| contains_pair(session,pair_to_exclude)}.reduce(true,:&)
    end
  else 
    sessions
  end
 end

 def self.contains_pair(session,pair)
  session.map { |session_pair| is_same_pair(pair,session_pair)}.reduce(false,:|)
 end

 def self.is_same_pair(pair1,pair2) 
  pair1.map { |member| pair2.include? member}.reduce(true,:&)
 end 
end