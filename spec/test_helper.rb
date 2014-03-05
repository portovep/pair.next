require 'rspec'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

require_relative '../environment.rb'

RSpec.configure do |conf|

  conf.include Rack::Test::Methods

  conf.around do |example|

    # Needed for testing Sinatra applications
    def app
      Sinatra::Application
    end

    example.run
  end

end
