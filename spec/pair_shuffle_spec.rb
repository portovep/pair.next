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
      
      new_teammembers = ["Lukas", "Florian", "Pablo", "Martino"]

      new_teammembers.each do |member|
      	new_member = User.create(username: member)
      	team_membership = TeamMember.create(user: new_member, team: @team)
      end
    end

    it 'should show shuffle page' do
      get "/team/#{@team.id}/shuffle", {}, session
      
      expect(last_response.body).to include("Profile - #{@team.name} - Shuffle Teams")
    end

    # it 'should show error for non existing team' do
    #   # non_existing_team_id = 1
    #   # get "/team/#{non_existing_team_id}", {}, session
      
    #   # expect(last_response.redirect?).to be_true

    #   # follow_redirect!
    #   # expect(last_response.body).to include("Team not found")
    # end

  end
end