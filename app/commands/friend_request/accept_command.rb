class FriendRequest::AcceptCommand
  include Command

  attr_reader :friend_request

  validate :validate_friend_request

  def run
    friend_request.status_accepted!

    UserFriend.create!(user: friend_request.from_user, friend_user: friend_request.to_user)
    UserFriend.create!(user: friend_request.to_user, friend_user: friend_request.from_user)
  end

  def initialize(friend_request:)
    @friend_request = friend_request
  end

  private

  def validate_friend_request
    errors.add(:friend_request, :invalid) if !friend_request.status_pending?
  end
end
