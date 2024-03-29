require 'rspec'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

require_relative '../environment.rb'

# Suppress deprecation warning
I18n.enforce_available_locales = false

RSpec.configure do |conf|

  conf.include Rack::Test::Methods

  conf.around do |example|

    # Needed for testing Sinatra applications
    def app
      Sinatra::Application
    end

    # Wrap all DB interactions in a transaction and rollback after
    ActiveRecord::Base.transaction do
      begin
        example.run
      ensure
        raise ActiveRecord::Rollback
      end
    end
  end

end
