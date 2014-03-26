require_relative '../test_helper.rb'

describe "User profile page" do

  context 'with a signed in user' do

    before(:each) do
      @user = User.create(username: 'bob@bob.com', nickname: 'bobby')
      @session = { 'rack.session' => { user_id: @user.username } }
    end

    it "displays hello and the users nickname" do
      get "/user/#{@user.id}", {}, @session
      expect(last_response.body).to include("Hello #{@user.nickname}!")
    end

    it "will list the users email address" do
      get "/user/#{@user.id}", {}, @session
      expect(last_response.body).to include("#{@user.username}")
    end

    it "allows a user to update their nickname" do
      post "/user/update", { new_nickname: "Johnny" }, @session
      expect(last_response.redirect?).to be_true

      follow_redirect!
      expect(last_response.body).to include("Hello Johnny!")
    end

    it "will direct a user to their own page if they attempt to access another users page "do
      another_users_id = @user.id - 1
      get "/user/#{another_users_id}", {} , @session
      expect(last_response.redirect?).to be_true
      follow_redirect!
      last_request.url.should == ("http://example.org/user/#{@user.id}")

    end

    it "will list all the teams a user is part of"do

      test_team = Team.create(name: "The cow team")
      test_team.users << @user
      test_team = Team.create(name: "A super cool team")
      test_team.users << @user

      teams = Team.all.to_a.select { |team| team.users.include? @user }
      get "/user/#{@user.id}", {}, @session

      expect(last_response.body).to include("The cow team")
      expect(last_response.body).to include("A super cool team")

    end

    it "will escape user input for nickname " do
      post "/user/update", { new_nickname: "<marquee>Johnny</marquee>" }, @session
      expect(last_response.redirect?).to be_true
      follow_redirect!
      expect(last_response.body).to include("&lt;marquee&gt;Johnny&lt;&#x2F;marquee&gt;")
    end

    it "will escape user input for bio " do
      post "/user/update", {  new_nickname: "Johnny", new_extra: "<marquee>I am a super awesome dev</marquee>" }, @session
      expect(last_response.redirect?).to be_true

      follow_redirect!
      expect(last_response.body).to include("&lt;marquee&gt;I am a super awesome dev&lt;&#x2F;marquee&gt;")
    end
  end

end
