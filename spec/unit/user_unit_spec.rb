require_relative '../test_helper.rb'

describe 'User' do

  it 'should produce the right image link' do
    user = User.new(username: 'vise890@gmail.com')
    expect(user.image_url).to eq("http://www.gravatar.com/avatar/8d6f61601881ec2f053899a7732c59ba")
  end

  describe 'nicknames' do
    it 'should get a nickname if none is provided' do
      fred = User.create(username: "fred@flinstone.com")
      expect(fred.nickname).to eq "fred"

      indi = User.create(username: "indiana@jones-corp.com", nickname: "")
      expect(indi.nickname).to eq "indiana"
    end

    it 'should preserve a nickname if one is provided' do
      elly = (User.create(username: "hellen@the-parrs.com", nickname: "elasti"))
      expect(elly.nickname).to eq "elasti"
    end
  end

  describe 'escaping' do 
    it 'should escape html tags in username' do 
      user = User.create(username: "<b>hello</b>")
      expect(user.username).to eq "&lt;b&gt;hello&lt;&#x2F;b&gt;"
    end

    it 'should escape html tags in nickname' do 
      user = User.create(nickname: "<b>hello</b>")
      expect(user.nickname).to eq "&lt;b&gt;hello&lt;&#x2F;b&gt;"
    end

    it 'should escape html tags in bio' do   
      user = User.create(bio: "<b>hello</b>")
      expect(user.bio).to eq "&lt;b&gt;hello&lt;&#x2F;b&gt;"
    end

    it 'should allow < characters' do 
      user = User.create(bio: "I <3 you");
      expect(user.bio).to eq "I &lt;3 you"
    end

  end

  describe 'count pairings' do
    before (:each) do
      @lukas = User.create(username: "Lukas")
      @florian = User.create(username: "Florian")
      @pablo = User.create(username: "Pablo")

      Pairing.create(users: [@lukas,@florian],team_id: 1)
      Pairing.create(users: [@lukas],team_id: 1)
    end

    it 'should count the number of pairings with another user if pairings exist' do
      @lukas.count_pairings_with(@florian,1).should be == 1
      @florian.count_pairings_with(@lukas,1).should be == 1
    end

    it 'should count the number of pairings with another user they didnt pair before' do
      @lukas.count_pairings_with(@pablo,1).should be == 0
      @pablo.count_pairings_with(@lukas,1).should be == 0
    end

    it 'should count pairings with no user at all' do
      @lukas.count_pairings_with(nil,1).should be == 1
      @pablo.count_pairings_with(nil,1).should be == 0
    end
  end

end
