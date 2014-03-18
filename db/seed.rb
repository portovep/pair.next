require_relative '../environment.rb'

team = Team.create(name: 'team-eu')

usernames = ['pablo@pablo.com', 'heyestom@gmail.com', 'vise890@gmail.com', 'lukas@pablo.com', 'tom@tom.com', 'florian@germans.com', 'fsellmay@thoughtworks.com' ]

usernames.each do |username|
  begin
    team.users << User.create(username: username)
  rescue
    next
  end
end


