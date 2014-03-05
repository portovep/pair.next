class Team < ActiveRecord::Base
	has_many :team_members
  validates :name, presence: true, uniqueness: true
end