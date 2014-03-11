require 'nokogiri'
require 'open-uri'
require_relative './test_helper.rb'

describe 'Pairing History' do

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

    it 'should show the teams pairing history' do
      get "/team/#{@team.id}/history", {}, session

      expect(last_response.body).to include("Pairing history")
    end
  end
end