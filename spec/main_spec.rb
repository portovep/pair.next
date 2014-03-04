require_relative './test_helper.rb'

describe 'Main' do

    it 'should say hello world' do
      get '/hi'
      expect(last_response.body).to include("Welcome to pair.next")
    end

end
