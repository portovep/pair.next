require 'rspec'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

require_relative '../environment.rb'
require_relative './test_utility_methods.rb'

# Suppress deprecation warning
I18n.enforce_available_locales = false

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
