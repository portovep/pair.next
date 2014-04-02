require 'digest/md5'

class User < ActiveRecord::Base
  has_many :team_members
  has_many :teams, through: :team_members

  has_many :pairing_memberships
  has_many :pairings, through: :pairing_memberships

  before_save :give_nickname

  def image_url(large = false)
    email_address = self.username.downcase
    hash = Digest::MD5.hexdigest(email_address)
    gravatar_url = "http://www.gravatar.com/avatar/#{hash}"
    gravatar_url += "?s=300" if large
    return gravatar_url
  end

  def count_pairings_with(other_user,team)
    if (other_user == nil)
      pairing_memberships.select { |membership| membership.pairing.users.count == 1 and membership.pairing.team_id == team}.count
    else
      pairing_memberships.select { |membership| membership.pairing.users.include? other_user and membership.pairing.team_id == team}.count
    end
  end

  def nickname
    clean(self[:nickname])
  end

  def bio
    clean(self[:bio])
  end

  def username
    clean(self[:username])
  end

  def member_of?(team)
    team.users.include? self
  end

  private def clean(text)
    Rack::Utils.escape_html(text)
  end

  def give_nickname
    if nickname.nil? || nickname.empty?
      self.nickname = self.username.split("@").first
    end
  end

end
