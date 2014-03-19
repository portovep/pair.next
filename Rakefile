require_relative './environment.rb'
require 'rake'
require 'active_support/core_ext'

desc "Create an empty migration in db/migrate, e.g., rake migration NAME=create_tasks"
task :migration do
  unless ENV.has_key?('NAME')
    raise "Must specificy migration name, e.g., rake migration NAME=create_tasks"
  end

  name     = ENV['NAME'].camelize
  filename = "%s_%s.rb" % [Time.now.strftime('%Y%m%d%H%M%S'), ENV['NAME'].underscore]
  path     = APP_ROOT.join('db', 'migrate', filename)

  if File.exist?(path)
    raise "ERROR: File '#{path}' already exists"
  end

  puts "Creating #{path}"
  File.open(path, 'w+') do |f|
    f.write(<<-EOF.strip_heredoc)
    class #{name} < ActiveRecord::Migration
      def change
      end
    end
    EOF
  end
end

desc "Create the database at #{DB_NAME}"
task :create do
  puts "Creating database #{DB_NAME} if it doesn't exist..."
  exec("createdb #{DB_NAME}")
end

desc "Drop the database at #{DB_NAME}"
task :drop do
  puts "Dropping database #{DB_NAME}..."
  exec("dropdb #{DB_NAME}")
end

desc "Migrate the database (options: VERSION=x, VERBOSE=false, SCOPE=blog)."
task :migrate do
  ActiveRecord::Migrator.migrations_paths << File.dirname(__FILE__) + 'db/migrate'
  ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
  ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths, ENV["VERSION"] ? ENV["VERSION"].to_i : nil) do |migration|
    ENV["SCOPE"].blank? || (ENV["SCOPE"] == migration.scope)
  end
end

desc "Populate db with testing data"
task :seed do
  require_relative 'db/seed.rb'
end

desc "Resets the database"
task :reset_db do
  puts "resetting the db with test data..."
  puts `rake drop ; rake create && rake migrate && rake seed`
end

desc "Fire up the development server"
task :shotgun do
  puts `shotgun --port 4567 --host 0.0.0.0`
end

desc "Fire up the production server"
task :serve do
  puts `rackup -D -p 4567`
end

desc 'Stop server'
task :stop do
  pid = `lsof -i :4567 -t`
  if !pid.nil? && !pid.empty?
    puts "Stopping server on port 4567"
    Process.kill 9, pid.to_i
  else
    puts "No server running on port 4567"
  end
end

desc "Run the tests"
task :test do
  puts `bundle exec rspec --color --format documentation`
end

desc "Returns the current schema version number"
task :version do
  puts "Current version: #{ActiveRecord::Migrator.current_version}"
end

desc 'Start PRY with application environment loaded'
task :console do
  exec "pry -r ./environment.rb"
end
