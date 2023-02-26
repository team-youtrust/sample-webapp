class FriendRequest::MarkAsReadCommand
  include Command

  attr_reader :operation_user, :friend_request

  validate :validate_to_user

  def run
    friend_request.update!(is_read: true)
  end

  def initialize(operation_user:, friend_request:)
    @operation_user = operation_user
    @friend_request = friend_request
  end

  private

  def validate_to_user
    errors.add(:friend_request, :invalid) if friend_request.to_user != operation_user
  end
end
