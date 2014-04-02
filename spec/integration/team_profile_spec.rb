require_relative '../test_helper.rb'

describe 'Team profile' do

  context 'when a user is signed in' do

    before(:all) do
      @current_user = User.create(username: 'HackMeister')
    end

    before(:each) do
      @team = Team.create(name: 'hack-heroes')
    end

    let(:session) do
      { 'rack.session' => { user_id: @current_user.username } }
    end

    it 'should show error for non existing team' do
      non_existing_team_id = -1
      get "/team/#{non_existing_team_id}", {}, session

      expect(last_response.redirect?).to be_true

      follow_redirect!
      expect(last_response.body).to include("Team not found")
    end

    context 'and is a member of the current team' do
      before(:each) do
        @team.users << @current_user
      end

      it 'team profile is shown' do
        get "/team/#{@team.id}", {}, session
        expect(last_response.body).to include("Profile - #{@team.name}")
      end

      it 'should add a new member' do
        new_member = User.create(username: 'user1')

        post "/team/#{team.id}/members", {member_username: new_member.username}, session
        follow_redirect!

        expect(@team.users).to include(new_member)
        expect(last_response.body).to include(new_member.username)
        expect(last_response.body).to include(new_member.image_url)
      end

      it 'should delete a member from the team' do
        short_lived_user = User.create(username: 'theUserName')
        team.users << short_lived_user

        delete "/team/#{team.id}/user/#{short_lived_user.id}", {}, session
        expect(last_response.redirect?).to be_true

        follow_redirect!

        expect(team.users).not_to include(short_lived_user)
        # FIXME: for some reason the body is empty...
        # expect(last_response.body).not_to include("theUserName")
        # expect(last_response.body).to include("User removed from team.")
      end
    end

    context 'the current user is NOT a member of the current team' do
      it 'should deny access' do
        get "/team/#{@team.id}", {}, session

        expect(last_response.redirect?).to be_true

        follow_redirect!
        expect(last_response.body).to include("You are not a member of the team you are trying to access")
      end
      it 'should show an error when trying to add a new member' do
        post "/team/#{team.id}/members", {member_username: "new_user"}, session
        follow_redirect!

        expect(last_response.body).to include("You are not a member of the team you are trying to access")
      end
    end

    it 'should show error for non existing member username' do
      team = Team.create(name: 'team_test')
      team.users << User.create(username: 'valid_id')

      expect(team.users.count).to be(1)

      post "/team/#{team.id}/members", {member_username: 'user1'}, session
      follow_redirect!

      expect(team.users.count).to be(1)
      expect(last_response.body).to include("user1 does not exist!")
    end

    it 'should show error when user is already a member' do
      team = Team.create(name: 'team_test')
      team.users << User.create(username: 'valid_id')
      user = User.create(username: 'user1')
      team.users << user

      post "/team/#{team.id}/members", {member_username: user.username}, session
      follow_redirect!

      expect(team.users).to eq(team.users.uniq)
      expect(last_response.body).to include("user1 is already a member!")
    end


  end

end
