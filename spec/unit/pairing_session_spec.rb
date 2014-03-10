require_relative '../test_helper.rb'

describe 'PairingSession' do

  before(:each) do
    @user1 = User.create(username: 'Mary')
    @user2 = User.create(username: 'Tom')
    @pairing_session = PairingSession.create()
  end

  describe '#add_pair' do

    it 'should add the user ids to the pairing session' do
      @pairing_session.add_pair(@user1, @user2)
      expect(@pairing_session.user_ids).to eq([@user1.id, @user2.id])
    end

  end

  describe '#users' do

    it 'should return the users in the pairing session' do
      @pairing_session.add_pair(@user1, @user2)
      expect(@pairing_session.users).to eq([@user1, @user2])
    end

  end

end
