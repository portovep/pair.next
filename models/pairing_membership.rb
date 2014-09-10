class PairingMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :pairing

  def self.find_by_team(team)
    PairingMembership.find_by_sql ["select * from pairing_memberships where pairing_id in (select id from pairings where team_id = ?)", team.id]
  end

  def self.find_current_by_user(user)
    memberships = PairingMembership.where(user_id: user.id)
    memberships.find { |membership| membership.pairing.end_time == nil }
  end


  def self.find_current_by_user_and_team(user, team)
    memberships = PairingMembership.where(user_id: user.id)
    memberships.find { |membership| membership.pairing.team_id == team.id and membership.pairing.end_time == nil }
  end
end
