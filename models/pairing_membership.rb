class PairingMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :pairing_session

  def self.find_by_team(team) 
    PairingMembership.find_by_sql ["select pm.* from pairing_memberships pm, users u where pm.user_id = u.id and exists (select * from team_members where user_id = u.id and team_id = ?)",team.id]
  end

  def self.find_current_by_user(user) 
    memberships = PairingMembership.where(user_id: user.id)
    memberships.find { |membership| membership.pairing_session.end_time == nil }
  end
end
