require_relative './test_helper.rb'

describe 'Pair shuffle' do

  context 'with a signed in user' do

    let(:session) do
      { 'rack.session' => { user_id: 'valid_id' } }
    end

    before(:each) do
      TeamMember.destroy_all
      Team.destroy_all
      User.destroy_all

      @team = Team.create(name: 'team_test')
      
      @new_teammembers = ["Lukas", "Florian", "Pablo", "Martino"]

      @new_teammembers.each do |member|
      	new_member = User.create(username: member)
      	team_membership = TeamMember.create(user: new_member, team: @team)
      end
    end

    it 'should show shuffle page for existing pairings' do
      TestUtilityMethods.create_pair("Lukas", "Florian")
      TestUtilityMethods.create_pair("Pablo", "Martino")

      get "/team/#{@team.id}/shuffle", {}, session
      
      expect(last_response.body).to include("Profile - #{@team.name} - Shuffle Teams")
      @new_teammembers.each do |member|
      	expect(last_response.body).to include(member)
      end
    end

    it 'should not show any pairs when new team accesses shuffle page' do
      get "/team/#{@team.id}/shuffle", {}, session
      
      expect(last_response.body).to include("Profile - #{@team.name} - Shuffle Teams")
      @new_teammembers.each do |member|
        expect(last_response.body).to_not include(member)
      end
    end
  end
end