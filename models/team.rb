class Team < ActiveRecord::Base
  has_many :team_members
  has_many :users, through: :team_members
  validates :name, presence: true, uniqueness: true
  # TODO: not all those methods actually belong in team
  def get_old_pairs
    team_members = self.team_members
    pairs = {}

    team_members.each do |team_member|
      user = team_member.user
      memberships = PairingMembership.where(user_id: user.id)

      membership = memberships.find do |membership|
        membership.pairing_session.end_time == nil
      end

      if membership != nil

        if pairs[membership.pairing_session_id] == nil
          pairs[membership.pairing_session_id] = []
        end

        pairs[membership.pairing_session_id] << user
      end
    end
    pairs.values
  end

  def end_old_pairings
    team_members.each do |team_member|
      user = team_member.user
      memberships = PairingMembership.where(user_id: user.id)

      membership = memberships.find do |membership|
        membership.pairing_session.end_time == nil
      end
      if membership != nil 
        pairing_session = membership.pairing_session
        pairing_session.end_time = Time.now
        pairing_session.save
      end 
    end
  end

  def all_possible_pairs 
    self.team_members.combination(2).to_a.map do |members|
      members.map do |member|
        member.user
      end
    end
  end

  def is_valid_pairing_session(session)
    pair_membership_counter = {}
    team_members.each { |member| pair_membership_counter[member.user] = 0 }
    session.each { |pair| pair.each {|user| pair_membership_counter[user] += 1 }}

    valid_user_entries = pair_membership_counter.select { |k,v| v == 1}
   
    valid_user_entries.count == pair_membership_counter.count
  end

  def all_possible_pairing_sessions 
    combinations = all_possible_pairs.combination(team_members.count/2)
    valid_combinations = combinations.select { |session| is_valid_pairing_session(session) }

    valid_combinations
  end

  def number_of_pairings_in_session(session) 
    session.map {|pair| pair[0].count_pairings_with(pair[1]) }.reduce(0,:+)
  end

  def shuffle_pairs
    pairing_number_map = all_possible_pairing_sessions.map { |session| [session,number_of_pairings_in_session(session)]}
    minimum_pairing_number = pairing_number_map.min_by { |session,pairing_number| pairing_number}[1]

    pairings_with_minimum_number = pairing_number_map.select { |session,pairing_number| pairing_number == minimum_pairing_number }.map {|session,pairing_number| session}

    pairings_with_minimum_number.shuffle.first
  end

  def pairing_history
    pairing_memberships_for_team = PairingMembership.find_by_team(self)
    memberships_by_time = pairing_memberships_for_team.group_by { |foo| foo.pairing_session.start_time.change(usec:0) }
    Hash[memberships_by_time.map { |time,memberships| 
      [time,memberships.group_by {|membership| 
        membership.pairing_session_id
      }.map {|session_id,pair_memberships| 
        pair_memberships.map{|membership| 
          membership.user
        }
      }]
    }]
  end

end
