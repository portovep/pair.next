require 'sinatra/activerecord'

db = URI.parse('postgres://user:pass@localhost/dbname')

DB_NAME = "pair_next"

ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8'
)