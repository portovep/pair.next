require_relative '../test_helper.rb'

describe 'Team' do

  before(:each) do
    @team = Team.create(name: 'uk-heroes') # sorry Germans, i needed an even number of people...

  end
  describe '#possible_pairs' do

    it 'should give a list of all the possible pair combinations' do
      team_members = %w[Tom Martino Pablo John]
      team_members.each do |member_name|
        @team.users << User.create(username: member_name)
      end

      # FIXME: tests implementation?
      expect(@team.possible_pairs).to eq(@team.users.combination(2).to_a)
    end

  end

  describe '#pairing_frequencies' do
    it 'should return a hash with the frequency at which each pair has occurred' do

      florian = User.create(username: "Florian")
      lukas = User.create(username: "lukas")
      martino = User.create(username: "martino")
      pablo = User.create(username: "pablo")
      tom = User.create(username: "tom")

      @team.users << florian
      @team.users << lukas
      @team.users << martino
      @team.users << pablo
      @team.users << tom

      1.times do
        PairingSession.create_with_users(users: [martino, tom])
      end
      4.times do
        PairingSession.create_with_users(users: [martino, pablo])
      end
      4.times do
        PairingSession.create_with_users(users: [florian, lukas])
      end

      pairing_frequencies = @team.pairing_frequencies

      expect(pairing_frequencies[0]).to include([lukas, martino])
      expect(pairing_frequencies[1]).to include([martino, tom])
      expect(pairing_frequencies[4]).to include([martino, pablo])
      expect(pairing_frequencies[4]).to include([florian, lukas])

    end
  end

  describe '#frequency_of([user1, user2])' do

    it 'should return the number of times the two users have paired' do
      @user1 = User.create(username: 'user1')
      @user2 = User.create(username: 'user2')
      PairingSession.create_with_users(users: [@user1, @user2])
      PairingSession.create_with_users(users: [@user2, @user1])
      PairingSession.create_with_users(users: [@user1, @user2])

      expect(@team.pairing_frequency_of([@user1, @user2])).to eq(3)
    end
  end
end
