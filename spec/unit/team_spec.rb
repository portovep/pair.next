require_relative '../test_helper.rb'

describe 'Team' do

  before(:each) do
    @team = Team.create(name: 'uk-heroes') # sorry Germans, i needed an even number of people...
    team_members = %w[Tom Martino Pablo John]
    team_members.each do |member_name|
      @team.users << User.create(username: member_name)
    end
  end

  describe '#possible_pairs' do
    it 'should give a list of all the possible pair combinations' do
      # FIXME: tests implementation?
      expect(@team.possible_pairs).to eq(@team.users.combination(2).to_a)
    end
  end

  describe '#pair_up' do
    it 'should make a pairing session for the given pair' do
      expect { @team.pair_up(random_pair) }.to change { @team.pairing_sessions.count}.by(1)
    end
  end

  describe 'pairing' do

    before(:each) do
      @florian = User.create(username: "Florian")
      @lukas = User.create(username: "lukas")
      @martino = User.create(username: "martino")
      @pablo = User.create(username: "pablo")
      @tom = User.create(username: "tom")
    end

    describe '#frequency_of([user1, user2])' do
      before(:each) do
        @team = Team.create(name: 'eu-boys')
        @team.users << [@florian, @lukas, @martino, @pablo, @tom]
      end
      it 'should return the number of times the two users have paired' do
        a_pair = [@tom, @florian]
        3.times do
          @team.pair_up(a_pair)
        end
        expect(@team.pairing_frequency_of(a_pair)).to eq(3)
        @team.pair_up(a_pair)
        expect(@team.pairing_frequency_of(a_pair)).to eq(4)
        expect(@team.pairing_frequency_of([@tom, @lukas])).to eq(0)
      end
      it 'should not take into account times when users have paired in another team' do
        a_pair = [@tom, @florian]
        3.times do
          @team.pair_up(a_pair)
        end
        Team.create(name: 'another team').pair_up(a_pair)
        expect(@team.pairing_frequency_of(a_pair)).to eq(3)
      end
    end

    describe '#pairing_frequency_table' do
      before(:each) do
        @team = Team.create(name: 'eu-boys')
        @team.users << [@florian, @lukas, @martino, @pablo, @tom]
      end
      it 'should return a hash with the frequency at which each pair has occurred' do
        1.times do
          @team.pair_up([@martino, @tom])
        end
        4.times do
          @team.pair_up([@martino, @pablo])
        end
        4.times do
          @team.pair_up([@florian, @lukas])
        end

        pairing_frequencies = @team.pairing_frequency_table
        expect(pairing_frequencies[0]).to include([@lukas, @martino])
        expect(pairing_frequencies[0]).not_to include([@florian, @lukas])
        expect(pairing_frequencies[0]).not_to include([@martino, @tom])
        expect(pairing_frequencies[0]).not_to include([@martino, @pablo])

        expect(pairing_frequencies[1]).to include([@martino, @tom])
        expect(pairing_frequencies[1]).not_to include([@lukas, @martino])
        expect(pairing_frequencies[1]).not_to include([@martino, @pablo])

        expect(pairing_frequencies[4]).to include([@martino, @pablo])
        expect(pairing_frequencies[4]).to include([@florian, @lukas])
      end
    end

    describe '#next_pairs' do
      before(:each) do
        @team = Team.create(name: 'eu-boys')
        @team.users << [@florian, @lukas, @martino, @pablo, @tom]
      end
      it 'should return a somewhat random list of people who have paired together less often' do
        1.times do
          @team.pair_up([@martino, @tom])
        end
        4.times do
          @team.pair_up([@martino, @pablo])
        end
        4.times do
          @team.pair_up([@florian, @lukas])
        end

        @team.next_pairs.each do |pair|
          # all the pairs that happened for times should not be the next pairs
          expect(@team.pairing_frequency_table[4]).not_to include(pair)
        end

        @team.next_pairs.each do |pair|
          # all the chosen pairs should hanve never paired before
          expect(@team.pairing_frequency_table[0]).to include(pair)
        end

      end
    end
  end

  private

  def random_pair
    @team.users.shuffle.first(2).sort
  end
end
