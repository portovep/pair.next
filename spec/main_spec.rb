require_relative './test_helper.rb'

describe 'Main' do

  context 'with a signed in user' do

    let(:session) do
      { 'rack.session' => { user_id: 'valid_id' } }
    end

    it 'should say hello world' do
      get '/hi', {}, session
      expect(last_response.body).to include("Welcome to pair.next")
    end

  end

end
