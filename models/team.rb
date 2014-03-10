class Team < ActiveRecord::Base
  has_many :team_members
  has_many :users, through: :team_members

  has_many :pairing_sessions

  validates :name, presence: true, uniqueness: true

  def pair_up(pair)
    self.pairing_sessions << PairingSession.create(users: pair)
  end

  def possible_pairs
    users.combination(2).to_a.map(&:sort)
  end

  # Return the number of times pair has paired together in the current team
  def pairing_frequency_of(pair)
    user_ids = pair.map(&:id)
    where_query = user_ids.map{ |id| "#{id} = ANY(user_ids)"}.join(" AND ")
    self.pairing_sessions.where(where_query).count
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
  def pairing_frequency_table
    # need to be careful with this; see
    # https://stackoverflow.com/questions/2698460/strange-ruby-behavior-when-using-hash-new
    pairing_frequency_table = Hash.new { [] }

    possible_pairs.each do |pair|
      frequency = pairing_frequency_of(pair)
      pairing_frequency_table[frequency] += [pair] # see above ^^
    end

    return pairing_frequency_table
  end

  def next_pairs
    @next_pairs = []

    frequencies_table = pairing_frequency_table() # cache this and remove chosen/invalid pairs as we go
    frequencies = frequencies_table.keys.sort # need this to access the hash in asc order

    frequencies.each do |frequency|

      loop do # consider all the pairs in this frequency
        next_pair = frequencies_table[frequency].shuffle!.pop # remove pairs as we visit them
        break if next_pair.nil? # if it's nil, we've exhausted the pairs at this freq, so move out of loop
        if valid_pair?(next_pair)
          @next_pairs << next_pair
        end
      end

    end

    return @next_pairs.take(needed_pairs) # only take the number of pairs we need
  end

  private

  # ensure that no member of pair has already been choosen in @next_pairs
  def valid_pair?(pair)
    chosen_users = @next_pairs.flatten
    !chosen_users.include?(pair.first) && !chosen_users.include?(pair.second)
  end

  def needed_pairs
    self.users.count / 2
  end

end
