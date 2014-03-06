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

      TestUtilityMethods.create_pair("Lukas", "Florian")
      TestUtilityMethods.create_pair("Pablo", "Martino")
    end

	it 'should get all old pairs' do
		old_pairs = @team.get_old_pairs
		old_pairs.should be == [[User.find_by_username("Lukas"), User.find_by_username("Florian")],
								[User.find_by_username("Pablo"), User.find_by_username("Martino")]]
	end
end
