class Team < ActiveRecord::Base
  has_many :team_members
  has_many :users, through: :team_members

  has_many :pairing_sessions

  validates :name, presence: true, uniqueness: true

  def pair_up(pair)
    self.pairing_sessions << PairingSession.create(users: pair)
  end

  def possible_pairs
    users.combination(2).to_a
  end

  # returns a hash with the frequencies with which a pair
  # has paired as keys and the pairs as values
  #
  # this is done for all the possible_pairs
  #
  # E.g.,
  # { 0: [[florian pablo] [pablo tom]]
  #   1: [[martino tom]]                    # [martino tom] have paired once
  #   4: [[martino pablo] [florian lukas]]  # [martino pablo] and [florian lukas] have paired 4 times
  #   .... and so on
  # }
  #
  def pairing_frequencies
    # this is somewhat expensive, so don't run it unnecessarily
    return @pairing_frequencies if @pairing_frequencies

    @pairing_frequencies = Hash.new([])
    possible_pairs.each do |pair|
      frequency_of_pair = pairing_frequency_of(pair)
      @pairing_frequencies[frequency_of_pair] << pair
    end

    return @pairing_frequencies
  end

  # Return the number of times users have paired together
  def pairing_frequency_of(users)
    user_ids = users.map(&:id)
    where_query = user_ids.map{ |id| "#{id} = ANY(user_ids)"}.join(" AND ")
    PairingSession.where(where_query).count
  end

end
