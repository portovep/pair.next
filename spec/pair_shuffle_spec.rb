require 'nokogiri'
require 'open-uri'
require_relative './test_helper.rb'

describe 'Pair shuffle' do

  context 'with a signed in user' do

    let(:session) do
      { 'rack.session' => { user_id: 'valid_id' } }
    end

    before(:each) do
      @team = Team.create(name: 'team_test')
      
      @new_teammembers = ["Lukas", "Florian", "Pablo", "Martino"]

      @new_teammembers.each do |member|
      	@team.users << User.create(username: member)
      end

      @team.save
    end

    it 'should show shuffle page for existing pairings' do
      TestUtilityMethods.create_pair("Lukas", "Florian")
      TestUtilityMethods.create_pair("Pablo", "Martino")

      get "/team/#{@team.id}/shuffle", {}, session
      parsed_doc = Nokogiri::HTML(last_response.body)
      parsed_doc_old_pairs = parsed_doc.css("#old-pairs").text
      parsed_doc_new_pairs = parsed_doc.css("#new-pairs").text
      
      expect(last_response.body).to include("Profile - #{@team.name} - Shuffle Teams")
      @new_teammembers.each do |member|
      	expect(parsed_doc_old_pairs).to include(member)
        expect(parsed_doc_new_pairs).to_not include(member)
      end
    end

    it 'should not show any pairs when new team accesses shuffle page' do
      get "/team/#{@team.id}/shuffle", {}, session

      parsed_doc = Nokogiri::HTML(last_response.body)
      parsed_doc_old_pairs = parsed_doc.css("#old-pairs").text
      parsed_doc_new_pairs = parsed_doc.css("#new-pairs").text
      
      expect(last_response.body).to include("Profile - #{@team.name} - Shuffle Teams")
      expect(parsed_doc_old_pairs).to include("No existing pairings")
      @new_teammembers.each do |member|
        expect(parsed_doc_old_pairs).to_not include(member)
        expect(parsed_doc_new_pairs).to_not include(member)
      end
    end

    it 'should show new team members after clicking on SHUFFLE' do
      TestUtilityMethods.create_pair("Lukas", "Florian")
      TestUtilityMethods.create_pair("Pablo", "Martino")
      
      post "/team/#{@team.id}/shuffle", {}, session

      parsed_doc = Nokogiri::HTML(last_response.body)
      parsed_doc_old_pairs = parsed_doc.css("#old-pairs").text
      parsed_doc_new_pairs = parsed_doc.css("#new-pairs").text

      expect(last_response.body).to include("Profile - #{@team.name} - Shuffle Teams")
      @new_teammembers.each do |member|
        expect(parsed_doc_old_pairs).to include(member)
        expect(parsed_doc_new_pairs).to include(member)
      end
    end
  end
end