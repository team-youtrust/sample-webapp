class FriendRequest::MarkAsReadUseCase
  include UseCase

  attr_reader :operation_user, :friend_request

  def run
    command = ApplicationRecord.transaction do
      lock_users
      FriendRequest::MarkAsReadCommand.run(operation_user: operation_user, friend_request: friend_request)
    end

    return if command && command.success?

    errors.add(:friend_request, :invalid)
  end

  def initialize(operation_user:, friend_request:)
    @operation_user = operation_user
    @friend_request = friend_request
  end

  private

  def lock_users
    User.lock_users(friend_request.from_user, friend_request.to_user)
  end
end
