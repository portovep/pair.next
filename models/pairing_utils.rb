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

 def self.find_best_sessions(sessions,count_for_users)
  pairing_number_map = Hash[sessions.map do |session| 
    pairing_number = session.number_of_pairings_in_session(count_for_users)
    [session,pairing_number]
  end]
  
  minimum_pairing_number = pairing_number_map.values.min

  pairing_number_map.select { |session,pairing_number| pairing_number == minimum_pairing_number }.keys
 end

 def self.find_best_sessions_for_team_members(team_members,to_exclude,count_for_users) 
  all_possible_pairing_sessions = all_possible_pairing_sessions(team_members)

  all_possible_pairing_sessions = filter_from_sessions_if_appropriate(all_possible_pairing_sessions,to_exclude)
 
  best_sessions = PairingUtils.find_best_sessions(all_possible_pairing_sessions,count_for_users)
  best_sessions    
 end

 def self.filter_from_sessions_if_appropriate(sessions,to_exclude) 
  if (sessions.count > 1) 
    sessions.select do |session|
      session != to_exclude
    end
  else 
    sessions
  end
 end
 
end