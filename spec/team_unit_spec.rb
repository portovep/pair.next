require_relative './test_helper.rb'

describe 'Team class' do

	before(:each) do
      TeamMember.destroy_all
      Team.destroy_all
      User.destroy_all

      @team = Team.create(name: 'team_test')
      
      @new_teammembers = ["Lukas", "Florian", "Pablo", "Martino"]

      @new_teammembers.each do |member|
      	new_member = User.create(username: member)
      	team_membership = TeamMember.create(user: new_member, team: @team)
      end

      start_time = Time.now
      end_time = start_time + (10*60)
      TestUtilityMethods.create_pair("Pablo", "Florian", start_time, end_time)
      TestUtilityMethods.create_pair("Lukas", "Martino", start_time, end_time)

      TestUtilityMethods.create_pair("Lukas", "Florian", end_time)
      TestUtilityMethods.create_pair("Pablo", "Martino", end_time)


    end

	it 'should get the most current old pairs' do
		old_pairs = @team.get_old_pairs
		old_pairs.should be == [[User.find_by_username("Lukas"), User.find_by_username("Florian")],
								[User.find_by_username("Pablo"), User.find_by_username("Martino")]]
	end
end
