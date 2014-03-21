class Team < ActiveRecord::Base
  has_many :team_members
  has_many :users, through: :team_members
  validates :name, presence: true, uniqueness: true

  before_validation :clean_input


  def get_current_pairs
    current_pairing_sessions.map {|session| session.users }
  end

  def current_pairing_sessions
    PairingSession.find_current_by_team(self)
  end

  def end_current_pairing_sessions # TODO: this is untested
    current_pairing_sessions.each do |pairing_session|
      pairing_session.end_time = Time.now
      pairing_session.save
    end
  end

  def team_member_users 
    team_members.map { |member| member.user}
  end

  def count_pairings_between(user1,user2) 
    user1.count_pairings_with(user2)
  end

  def shuffle_pairs
    all_possible_pairing_sessions = PairingUtils.all_possible_pairing_sessions(team_member_users)

    best_sessions = PairingUtils.find_best_sessions(all_possible_pairing_sessions,method(:count_pairings_between))

    best_sessions.shuffle.first
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

   def pairing_statistics 
     all_possible_pairs = PairingUtils.all_possible_pairs(users)
     Hash[all_possible_pairs.map { |pair| [pair,pair[0].count_pairings_with(pair[1])]}]
   end

  private
  def clean_input
    self.name = Sanitize.clean(self.name)
  end
end
