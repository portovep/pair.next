require_relative '../test_helper.rb'

describe 'PairingSession' do

  before(:each) do
    @user1 = User.create(username: 'Mary')
    @user2 = User.create(username: 'Tom')
  end


  describe '.create_with_users' do

    it 'should add the user ids to the pairing session' do
      p = PairingSession.create_with_users(users: [@user1, @user2])
      expect(p.user_ids).to eq([@user1.id, @user2.id])
    end

    it 'should always add the user ids in the same order' do
      p1 = PairingSession.create_with_users(users: [@user1, @user2])
      p2 = PairingSession.create_with_users(users: [@user2, @user1])
      expect(p1.user_ids).to eq(p2.user_ids)
    end

  end

  describe '#users' do

    it 'should return the users in the pairing session' do
      pairing_session = PairingSession.create_with_users(users: [@user1, @user2])
      expect(pairing_session.users).to eq([@user1, @user2])
    end

  end

  describe '.frequency_of([user1, user2])' do

    it 'should return the number of times the two users have paired' do
      PairingSession.create_with_users(users: [@user1, @user2])
      PairingSession.create_with_users(users: [@user2, @user1])
      PairingSession.create_with_users(users: [@user1, @user2])

      expect(PairingSession.frequency_of([@user1, @user2])).to eq(3)
    end
  end

end
