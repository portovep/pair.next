class Pairing < ActiveRecord::Base
  has_many :pairing_memberships
  has_many :users, through: :pairing_memberships
  belongs_to :team
  def self.find_current_by_team(team)
    current_pairing_memberships = team.team_members.map { |member|   PairingMembership.find_current_by_user(member.user) }.select { |membership| membership != nil and membership.pairing.team_id == team.id}
    current_pairing_memberships.group_by { |membership| membership.pairing }.keys
  end
end
