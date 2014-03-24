class Team < ActiveRecord::Base
  has_many :team_members
  has_many :users, through: :team_members
  validates :name, presence: true, uniqueness: true

  before_validation :clean_input


  def get_current_pairs
    current_pairings.map {|pairing| pairing.users }
  end

  def current_pairings
    Pairing.find_current_by_team(self)
  end

  def end_current_pairings # TODO: this is untested
    current_pairings.each do |pairing|
      pairing.end_time = Time.now
      pairing.save
    end
  end

  def team_member_users 
    team_members.map { |member| member.user}
  end

  def count_pairings_between(user1,user2) 
    user1.count_pairings_with(user2)
  end

  def shuffle_pairs
    best_pairings = PairingUtils.find_best_sessions_for_team_members(team_member_users,get_current_pairs,method(:count_pairings_between))

    best_pairings.shuffle.first
  end

  def pairing_history
    pairing_memberships_for_team = PairingMembership.find_by_team(self)
    memberships_by_time = pairing_memberships_for_team.group_by { |foo| foo.pairing.start_time.change(usec:0) }
    Hash[memberships_by_time.map { |time,memberships| 
      [time,memberships.group_by {|membership| 
        membership.pairing_id
      }.map {|pairing_id,pair_memberships| 
        pair_memberships.map{|membership| 
          membership.user
        }
      }]
    }]
  end

   def pairing_statistics 
     all_possible_pairs = PairingUtils.all_possible_pairs(users).map{|pair| pair.members}
     Hash[all_possible_pairs.map { |pair| [pair,pair[0].count_pairings_with(pair[1])]}]
   end

  private
  def clean_input
    self.name = Sanitize.clean(self.name)
  end
end
