require 'digest/md5'

class User < ActiveRecord::Base
  has_many :team_members
  has_many :teams, through: :team_members

  has_many :pairing_memberships
  has_many :pairing_sessions, through: :pairing_memberships

  before_validation :clean_input
  before_save :give_nickname

  def image_url(large = false)
    email_address = self.username.downcase
    hash = Digest::MD5.hexdigest(email_address)
    gravatar_url = "http://www.gravatar.com/avatar/#{hash}"
    gravatar_url += "?s=300" if large
    return gravatar_url
  end

  def count_pairings_with(other_user)
    if (other_user == nil)
      pairing_memberships.select { |membership| membership.pairing_session.users.count == 1}.count
    else
      pairing_memberships.select { |membership| membership.pairing_session.users.include? other_user}.count
    end
  end

  private

  def clean_input
    self.username = Sanitize.clean(self.username)
    self.bio = Sanitize.clean(self.bio)
    self.nickname = Sanitize.clean(nickname)
  end

  def give_nickname
    if nickname.nil? || nickname.empty?
      self.nickname = self.username.split("@").first
    end
  end

end
