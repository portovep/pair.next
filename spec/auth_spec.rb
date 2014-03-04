require_relative "./test_helper.rb"

describe "authentication" do
  context "when logged in" do
    let(:session) do
	    { "rack.session" => { user_id: "logged in" } }
    end
    it "can access protected routes" do
      get "/hi", {} , session
      expect(last_response.redirect?).to be(false)
    end
  end

  context "when logged out" do
    let(:session) do
      { "rack.session" => { user_id: nil}}
    end
    it "can not access protected routes" do
      get "/hi", {} , session
      expect(last_response.redirect?).to be(true)
    end
  end
end

