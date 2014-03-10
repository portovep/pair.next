class PairingSession < ActiveRecord::Base

  # this is mainly glue for inserting and getting
  # back User objects (while storing their ids in a psql array)
  #
  # TODO: 10/3/14 Martino - if I destroy a user, her pairing sessions should also go

  def initialize(args)
    if args[:users]
      super(standard_args(args))
    else
      super(args)
    end
  end

  def users
    self.user_ids.map { |id| User.find_by_id(id) }
  end

  # TODO: implement users<<

  private
  def standard_args(args)
    user_ids = args.delete(:users).map(&:id).sort
    args[:user_ids] = user_ids
    args
  end

end
