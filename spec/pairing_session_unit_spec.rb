require_relative './test_helper.rb'

describe 'PairingSession class' do
  before(:each) do
    @team = Team.create(name: "team_test")

    @lukas = User.create(username: "Lukas",teams: [@team])
    @florian = User.create(username: "Florian",teams: [@team])

    @other_team = Team.create(name: "other_team")
  
    @martino = User.create(username: "Martino",teams: [@other_team])
    @pablo = User.create(username: "Pablo",teams: [@other_team])

    @session = PairingSession.create(users: [@lukas,@florian])
  end

  it 'should find current PairingSessions by team' do
    PairingSession.find_current_by_team(@team).should match_array [@session]
  end
end