require 'sinatra/activerecord'
DB_NAME = "pair_next"
db = URI.parse(ENV['DATABASE_URL'] || "postgres://postgres:postgres@localhost/#{DB_NAME}")

ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :username => ENV['PG_USER'] || db.user,
  :password => ENV['PG_PASS'] || db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8'
)