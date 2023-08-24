class FriendRequest::MarkAsReadCommand
  include Command

  attr_reader :friend_request

  def run
    friend_request.update!(is_read: true)
  end

  def initialize(friend_request:)
    @friend_request = friend_request
  end
end
