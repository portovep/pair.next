require_relative './test_helper.rb'

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

    it "allows a user to update their nickname" do
    	post "/user/update", { new_nickname: "Johnny" }, @session
    	expect(last_response.redirect?).to be_true

    	follow_redirect!
    	expect(last_response.body).to include("Hello Johnny!")
    end

	end	

end