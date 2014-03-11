require_relative './test_helper.rb'

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
    end

    it 'should count the number of pairings with another user if pairings exist' do 
      @lukas.count_pairings_with(@florian).should be == 1 
      @florian.count_pairings_with(@lukas).should be == 1 
    end

    it 'should count the number of pairings with another user they didnt pair before' do 
      @lukas.count_pairings_with(@pablo).should be == 0 
      @pablo.count_pairings_with(@lukas).should be == 0
    end
  end

end