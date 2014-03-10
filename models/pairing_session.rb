class PairingSession < ActiveRecord::Base

  # this is mainly glue for inserting and getting
  # back User objects (while storing their ids in a psql array)
  #
  # TODO: 10/3/14 Martino - if I destroy a user, her pairing sessions should also go

  def self.create_with_users(args)
    self.create(user_ids: args[:users].map(&:id).sort)
  end

  def users
    self.user_ids.map { |id| User.find_by_id(id) }
  end

  # TODO: implement users<<

end
