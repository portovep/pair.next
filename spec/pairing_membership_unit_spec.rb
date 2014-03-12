require_relative './test_helper.rb'

describe 'Team class' do
  before(:each) do
    @team = Team.create(name: "team_test")

    @lukas = User.create(username: "Lukas",teams: [@team])
    @florian = User.create(username: "Florian",teams: [@team])

    @other_team = Team.create(name: "other_team")
  
    @martino = User.create(username: "Martino",teams: [@other_team])
    @pablo = User.create(username: "Pablo",teams: [@other_team])
  end

  it 'should fine memberships by team' do
    theSession = PairingSession.create(users: [@lukas,@florian])
    PairingSession.create(users: [@martino,@pablo])

    lukasMembership = PairingMembership.find_by_user_id(@lukas.id)
    florianMembership = PairingMembership.find_by_user_id(@florian.id)

    PairingMembership.find_by_team(@team).should match_array [lukasMembership,florianMembership]
  end
end