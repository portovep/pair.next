require_relative './test_helper.rb'

describe 'Team setup' do

  context 'with a signed in user' do

    let(:session) do
      { 'rack.session' => { user_id: 'valid_id' } }
    end

    before(:each) do
      Team.destroy_all
      User.destroy_all
    end

    it 'should show team profile' do
      team = Team.create(name: 'team_test')

      get "/team/#{team.id}", {}, session
      
      expect(last_response.body).to include("Profile - #{team.name}")
    end

    it 'should show error for non existing team' do
      non_existing_team_id = 1
      get "/team/#{non_existing_team_id}", {}, session
      
      expect(last_response.redirect?).to be_true

      follow_redirect!
      expect(last_response.body).to include("Team not found")
    end

    it 'should add a new member to a team' do
      team = Team.create(name: 'team_test')
      user = User.create(username: 'user1')

      expect(team.users).to be_empty

      post "/team/#{team.id}/members", {member_username: 'user1'}, session

      expect(team.users).to include(user)
      #expect(last_response.body).to include("user1")
    end

    it 'should show error for non existing member username' do
      team = Team.create(name: 'team_test')

      expect(team.users).to be_empty

      post "/team/#{team.id}/members", {member_username: 'user1'}, session

      expect(team.users).to be_empty
      #expect(last_response.body).to include("error")
    end

  end

end