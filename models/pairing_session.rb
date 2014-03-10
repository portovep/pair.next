class PairingSession < ActiveRecord::Base

  # this is mainly glue for inserting and getting
  # back User objects (while storing their ids in a psql array)
  #
  # TODO: 10/3/14 Martino - if I destroy a user, her pairing sessions should also go
  # FIXME: 10/3/14 Martino - implement .create and #initialize. I tried and it didn't seem trivial


  def add_pair(*users)
    self.user_ids = users.map(&:id)
  end

  def users
    self.user_ids.map { |id| User.find_by_id(id) }
  end

  # TODO: implement users<<
end
