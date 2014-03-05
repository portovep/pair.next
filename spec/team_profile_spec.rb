require_relative './test_helper.rb'

describe 'Team setup' do

  context 'with a signed in user' do

    let(:session) do
      { 'rack.session' => { user_id: 'valid_id' } }
    end

    before(:each) do
      Team.destroy_all
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

  end

end