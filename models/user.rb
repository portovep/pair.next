require 'digest/md5'

class User < ActiveRecord::Base
  has_many :team_members
  has_many :teams, through: :team_members

  has_many :pairing_memberships
  has_many :pairing_sessions, through: :pairing_memberships
  

  def image_url   
    email_address = self.username.downcase
    hash = Digest::MD5.hexdigest(email_address)
    "http://www.gravatar.com/avatar/#{hash}"
  end

  def large_image_url   
    email_address = self.username.downcase
    hash = Digest::MD5.hexdigest(email_address)
    "http://www.gravatar.com/avatar/#{hash}?s=300"
  end

  def count_pairings_with(other_user)
    if (other_user==nil) 
      pairing_memberships.select { |membership| membership.pairing_session.users.count == 1}.count
    else 
      pairing_memberships.select { |membership| membership.pairing_session.users.include? other_user}.count
    end
  end

  def shortname 
    nickname
  end

  def is_ghost 
    username == "Balthasar"
  end
end
