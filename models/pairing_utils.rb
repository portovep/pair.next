class PairingUtils
  def self.all_possible_pairs(team_members)
        team_members.combination(2).to_a
  end
  
end