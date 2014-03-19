require_relative '../environment.rb'

team = Team.create(name: 'team-eu')

usernames = ['pablo@pablo.com', 'heyesbob@gmail.com', 'vise890@gmail.com', 'lukas@pablo.com', 'tom@tom.com','fsellmay@thoughtworks.com' ]

usernames.each do |username|
  begin
  	nickname = username[/[^@]+/]
    team.users << User.create(username: username, nickname: nickname)
  rescue
    next
  end
end


