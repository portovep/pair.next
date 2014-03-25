require_relative '../test_helper.rb'

describe Pairing do

  before(:each) do
    @team = Team.create(name: "team_test")

    @lukas = User.create(username: "Lukas",teams: [@team])
    @florian = User.create(username: "Florian",teams: [@team])

    @other_team = Team.create(name: "other_team")

    @martino = User.create(username: "Martino",teams: [@other_team])
    @pablo = User.create(username: "Pablo",teams: [@other_team])

    @pairing = Pairing.create(users: [@lukas,@florian],team: @team)
  end

  it 'should find current Pairings by team' do
    Pairing.find_current_by_team(@team).should match_array [@pairing]
  end
end
