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
    team_members = self.team_members
    pairs = []

    team_members.each_slice(2) do |pair| 
      pairs << pairs
    end

    pairs
  end
end
