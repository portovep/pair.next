require_relative '../test_helper.rb'

describe 'PairingMembership class' do
  before(:each) do
    @team = Team.create(name: "team_test")

    @lukas = User.create(username: "Lukas",teams: [@team])
    @florian = User.create(username: "Florian",teams: [@team])

    @other_team = Team.create(name: "other_team")

    @martino = User.create(username: "Martino",teams: [@other_team])
    @pablo = User.create(username: "Pablo",teams: [@other_team])
  end

  it 'should find memberships by team' do
    Pairing.create(users: [@lukas,@florian])
    Pairing.create(users: [@martino,@pablo])

    lukasMembership = PairingMembership.find_by_user_id(@lukas.id)
    florianMembership = PairingMembership.find_by_user_id(@florian.id)

    PairingMembership.find_by_team(@team).should match_array [lukasMembership,florianMembership]
  end

  describe 'find_current_by_user' do
    before(:each) do
      @pairing = Pairing.create(users: [@lukas,@florian])
    end

    it 'should find current pairingMembership for a user with a current pairingMembership' do
      membership = PairingMembership.find_current_by_user(@lukas)
      membership.should be == @pairing.pairing_memberships.find { |membership| membership.user_id = @lukas.id }
    end

    it 'should return nil for a user without pairingMemberships' do
      membership = PairingMembership.find_current_by_user(@pablo)
      membership.should be == nil
    end

    it 'should return nil for a user with only closed pairingMemberships' do
      closed_pairing = Pairing.create(users: [@martino,@pablo], start_time: Time.now - 10, end_time: Time.now)

      membership = PairingMembership.find_current_by_user(@pablo)
      membership.should be == nil
    end
  end
end
