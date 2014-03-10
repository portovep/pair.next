require_relative "../test_helper.rb"

describe "authentication" do

  context "when logged in" do
    let(:session) do
      { "rack.session" => { user_id: "logged in" } }
    end
    it "can access protected routes" do
      get "/team/new", {} , session
      expect(last_response.redirect?).to be(false)
    end
    it "can access regular routes" do
      get "/hi", {} , session
      expect(last_response.redirect?).to be(false)
    end
  end

  context "when logged out" do
    let(:session) do
      { "rack.session" => { user_id: nil}}
    end
    it "can not access protected routes" do
      get "/team/new", {} , session
      expect(last_response.redirect?).to be(true)
    end
    it "can access regular routes" do
      get "/hi", {} , session
      expect(last_response.redirect?).to be(false)
    end
  end

  describe "user persistence" do

    # Always respond with a valid OmniAuth response
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:saml, {:uid => 'my_username'})

    it "saves the user on their first login" do
      expect(User.where(username: "my_username").count).to be(0)
      post "/auth/saml/callback"
      expect(User.where(username: "my_username").count).to be(1)
    end

    it "doesn't create the user again on subsequent logins" do
      User.create(username: 'my_username')
      post "/auth/saml/callback"
      expect(User.where(username: "my_username").count).to be(1)
    end

  end

end
