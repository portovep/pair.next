require_relative '../test_helper.rb'

describe 'Team setup' do

  context 'with a signed in user' do

    let(:session) do
      { 'rack.session' => { user_id: 'valid_id' } }
    end

    before(:each) do
      @current_user = User.create(username: 'valid_id')
    end

    it 'should show team creation page' do
      get '/team/new', {}, session
      expect(last_response.body).to include("Create a team")
    end

    it 'should create a new team and save it to the db' do
      expect(Team.find_by_name('my team')).to be_nil

      post '/team/new', { team_name: 'my team'}, session

      expect(last_response.redirect?).to be_true

      follow_redirect!
      expect(last_response.body).to include('Team my team successfully created')
      expect(last_response.body).to include('Profile - my team')
      expect(Team.find_by_name('my team').name).to eq 'my team'
    end

    it 'should not create a new team when team name is blank' do
      post '/team/new', { team_name: ''}, session

      expect(Team.find_by_name('')).to be_nil
      expect(last_response.body).to include("Name can't be blank")
    end

    it 'should not create a new team when team name is duplicated' do
      Team.create(name: 'myteam')
      post '/team/new', { team_name: 'myteam'}, session

      expect(Team.where(name: 'myteam').count).to eq(1)
      expect(last_response.body).to include("Name has already been taken")
    end

    it 'should add creator as a team member on creation' do
      post '/team/new', { team_name: 'my_team'}, session

      team = Team.find_by_name('my_team')
      expect(team.users).to include(@current_user)
    end

    it "will santatise user input for name " do
      post "/team/new", { team_name: "<marquee>hacker team</marquee>" }, session
      expect(last_response.redirect?).to be_true

      follow_redirect!
      expect(last_response.body).to include('Team hacker team successfully created')
      expect(last_response.body).to include('Profile - hacker team')
      expect(Team.find_by_name('hacker team').name).to eq 'hacker team'
    end

  end

end
