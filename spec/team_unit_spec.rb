require_relative './test_helper.rb'

describe 'Team class' do

	before(:each) do
            @team = Team.create(name: 'team_test')
            
            @new_teammembers = ["Lukas", "Florian", "Pablo", "Martino"]

            @new_teammembers.each do |member|
            	new_member = User.create(username: member)
            	team_membership = TeamMember.create(user: new_member, team: @team)


      end
            @lukas = User.find_by_username("Lukas")
            @florian = User.find_by_username("Florian")
            @pablo = User.find_by_username("Pablo")
            @martino = User.find_by_username("Martino")
    end

	it 'should get the most current old pairs' do
            start_time = Time.now
            end_time = start_time + (10*60)
            TestUtilityMethods.create_pair("Pablo", "Florian", start_time, end_time)
            TestUtilityMethods.create_pair("Lukas", "Martino", start_time, end_time)

            TestUtilityMethods.create_pair("Lukas", "Florian", end_time)
            TestUtilityMethods.create_pair("Pablo", "Martino", end_time)

		old_pairs = @team.get_old_pairs
		old_pairs.should be == [[User.find_by_username("Lukas"), User.find_by_username("Florian")],
								[User.find_by_username("Pablo"), User.find_by_username("Martino")]]
	end

      it 'should return empty array when no pairings exist' do
            old_pairs = @team.get_old_pairs
            old_pairs.should be == []
      end

      it 'should shuffle pairs when no previous pairings exist' do 
            new_pairs = @team.shuffle_pairs
            new_pairs.size.should be == 2
            new_pairs[0].size.should be == 2
            new_pairs[1].size.should be == 2
      end 

      it 'should output all possible pairings' do 
            possible_pairings = @team.all_possible_pairings
            expected_pairings = [[@lukas, @florian],[@lukas,@martino],[@lukas,@pablo],[@florian,@martino], [@florian,@pablo], [@pablo,@martino]]

            possible_pairings.should match_array expected_pairings
      end

      it 'should find number of pairings between two people when they didnt pair before' do 
            number_of_pairings = @team.number_of_pairings_between(@florian,@lukas)
            number_of_pairings.should be == 0
      end

      it 'should find number of pairings between two people when they paired before' do 
            TestUtilityMethods.create_pair("Lukas", "Florian")
            TestUtilityMethods.create_pair("Pablo", "Martino")
            number_of_pairings = @team.number_of_pairings_between(@florian,@lukas)
            number_of_pairings.should be == 1
      end

      # TODO
      it 'should generate only possible pairing solution left' do
            start_time = Time.now
            end_time = start_time + (10*60)
            TestUtilityMethods.create_pair("Pablo", "Florian", start_time, end_time)
            TestUtilityMethods.create_pair("Lukas", "Martino", start_time, end_time)

            TestUtilityMethods.create_pair("Lukas", "Florian", end_time)
            TestUtilityMethods.create_pair("Pablo", "Martino", end_time)

            new_pairs = @team.shuffle_pairs
            new_pairs.should be == [[User.find_by_username("Lukas"), User.find_by_username("Pablo")],
                                                [User.find_by_username("Florian"), User.find_by_username("Martino")]]
      end
end
