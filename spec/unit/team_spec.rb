require_relative '../test_helper.rb'

describe 'Team' do

  describe '#possible_pairs' do

    it 'should give a list of all the possible pair combinations' do
      team = Team.create(name: 'uk-heroes') # sorry Germans, i needed an even number of people...
      team_members = %w[Tom Martino Pablo John]
      team_members.each do |member_name|
        team.users << User.create(username: member_name)
      end

      # FIX: tests implementation?
      expect(team.possible_pairs).to eq(team.users.combination(2).to_a)
    end

  end
end
