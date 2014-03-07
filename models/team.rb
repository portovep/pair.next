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

  def all_possible_pairings 
    self.team_members.combination(2).to_a.map do |members|
      members.map do |member|
        member.user
      end
    end
  end

  def number_of_pairings_between(user1,user2)
    pairing_memberships_with_user2 = user1.pairing_memberships.select { |membership| membership.pairing_session.users.include? user2}
    pairing_memberships_with_user2.count
  end 

  def shuffle_pairs
    pairing_numbers = all_possible_pairings.map do |pair| 
      [pair, number_of_pairings_between(pair[0],pair[1])]
    end

    sorted = pairing_numbers.sort_by { |entry| entry[1]}

    number_of_pairs = team_members.count/2
    new_pairs = []
    paired_users = []

    while (paired_users.count <= number_of_pairs ) do 
      next_pair = sorted.shift[0]
      if not paired_users.include? next_pair[0] and not paired_users.include? next_pair[1] 
        new_pairs << next_pair
        paired_users << next_pair[0]
        paired_users << next_pair[1]
      end
    end

    new_pairs
  end
end
