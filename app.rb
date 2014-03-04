require "sinatra"

set :app_file, __FILE__

get '/hi' do
  erb :index
end
