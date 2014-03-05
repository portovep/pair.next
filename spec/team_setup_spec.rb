require_relative './test_helper.rb'

describe 'Team setup' do

  context 'with a signed in user' do

    let(:session) do
      { 'rack.session' => { user_id: 'valid_id' } }
    end

    it 'should show team creation page' do
      get '/team/new', {}, session
      expect(last_response.body).to include("Create a team")
    end

    it 'should create a new team' do
      post '/team/new', { team_name: 'my team', member1: 'bob' }, session
      expect(last_response.body).to include('Team successfully created')
    end

  end

end