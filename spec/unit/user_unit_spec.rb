require_relative '../test_helper.rb'

describe 'User' do

  it 'should produce the right image link' do
    user = User.new(username: 'vise890@gmail.com')
    expect(user.image_url).to eq("http://www.gravatar.com/avatar/8d6f61601881ec2f053899a7732c59ba")
  end

  describe 'count pairings' do
    before (:each) do
      @lukas = User.create(username: "Lukas")
      @florian = User.create(username: "Florian")
      @pablo = User.create(username: "Pablo")

      PairingSession.create(users: [@lukas,@florian])
      PairingSession.create(users: [@lukas])

    end

    it 'should count the number of pairings with another user if pairings exist' do
      @lukas.count_pairings_with(@florian).should be == 1
      @florian.count_pairings_with(@lukas).should be == 1
    end

    it 'should count the number of pairings with another user they didnt pair before' do
      @lukas.count_pairings_with(@pablo).should be == 0
      @pablo.count_pairings_with(@lukas).should be == 0
    end

    it 'should count pairings with no user at all' do
      @lukas.count_pairings_with(nil).should be == 1
      @pablo.count_pairings_with(nil).should be == 0
    end
  end

  it 'should have a shortname which is the username without the email domain' do
      username1 = 'foo@thoughtworks.com'
      nickname1 = username1[/[^@]+/]
      username2 = 'bar@baz.com'
      nickname2 = username2[/[^@]+/]
      User.new(username: username1,nickname: nickname1).shortname.should be == "foo"
      User.new(username: username2,nickname: nickname2).shortname.should be == "bar"
  end

end
