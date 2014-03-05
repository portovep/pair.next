require './app'
require 'rake'
require 'active_support/core_ext'

desc "Create an empty migration in db/migrate, e.g., rake generate:migration NAME=create_tasks"
task :migration do
	unless ENV.has_key?('NAME')
		raise "Must specificy migration name, e.g., rake generate:migration NAME=create_tasks"
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

desc "Fire up the server"
task :shotgun do
	`ruby app.rb`
end