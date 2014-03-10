require_relative '../test_helper.rb'

describe 'PairingSession' do

  before(:each) do
    @user1 = User.create(username: 'Mary')
    @user2 = User.create(username: 'Tom')
    @team = Team.create(name: 'eu-heroes')
  end

  describe '#initialize' do
    it 'should work as usual' do
      p = PairingSession.new(user_ids: [@user1.id, @user2.id])
      expect(p.user_ids).to eq([@user1.id, @user2.id])
    end
    it 'should work with users' do
      p = PairingSession.new(users: [@user1, @user2])
      expect(p.user_ids).to eq([@user1.id, @user2.id])
    end
  end

  describe 'belonging to a team' do
    it "should be addedd to a team's pairing_sessions" do
      team = Team.create(name: 'foo-fighters')
      pairing_session = PairingSession.create(users: [@user1, @user2])
      team.pairing_sessions << pairing_session
      expect(team.pairing_sessions).to include(pairing_session)
      expect(pairing_session.team).to eq(team)
    end
  end

  describe '.create' do
    it 'should work as usual' do
      p = PairingSession.create(user_ids: [@user1.id, @user2.id])
      expect(p.user_ids).to eq([@user1.id, @user2.id])
    end
    it 'should work with users' do
      p = PairingSession.create(users: [@user1, @user2])
      expect(p.user_ids).to eq([@user1.id, @user2.id])
    end
    it 'should always add the user ids in the same order' do
      p1 = PairingSession.create(users: [@user1, @user2])
      p2 = PairingSession.create(users: [@user2, @user1])
      expect(p1.user_ids).to eq(p2.user_ids)
    end
  end

  describe '#users' do
    it 'should return the users in the pairing session' do
      pairing_session = PairingSession.create(users: [@user1, @user2])
      expect(pairing_session.users).to eq([@user1, @user2])
    end
  end


end
