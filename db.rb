require 'sinatra/activerecord'
DB_NAME = "pair_next"
db = URI.parse("postgres://postgres:postgres@localhost/#{DB_NAME}")

ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8'
)