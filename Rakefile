require './app'
# Predefined rake tasks for creating migrations etc, seem not to work.
# require 'sinatra/activerecord/rake'

task :shotgun do
  `ruby app.rb`
end

task :test do
  puts `bundle exec rspec`
end
