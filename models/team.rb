class Team < ActiveRecord::Base
	has_many :team_members
  validates :name, presence: true, uniqueness: true

  def get_old_pairs
  	team_members = self.team_members
  	pairs = {}

  	team_members.each do |team_member|
  		user = team_member.user
  		memberships = PairingMembership.where(user_id: user.id)
      membership = memberships.find do |membership|
        membership.pairing_session.end_time == nil
      end

  		if pairs[membership.pairing_session_id] == nil
  			pairs[membership.pairing_session_id] = []	
  		end 
  		pairs[membership.pairing_session_id] << user
  	end

  	pairs.values
  end
end