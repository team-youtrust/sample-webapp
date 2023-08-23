class FriendRequest::AcceptUseCase
  include UseCase

  attr_reader :operation_user, :friend_request

  validate :validate_operation_user

  def run
    command = ApplicationRecord.transaction do
      lock_users
      FriendRequest::AcceptCommand.run(friend_request: friend_request)
    end

    if command && command.success?
      enqueue_notification_job
    else
      errors.add(:friend_request, :invalid)
    end
  end

  def initialize(operation_user:, friend_request:)
    @operation_user = operation_user
    @friend_request = friend_request
  end

  private

  def lock_users
    User.lock_users(friend_request.from_user, friend_request.to_user)
  end

  def enqueue_notification_job
    NotificationJob.perform_later(:accept_friend_request, friend_request: friend_request)
  end

  def validate_operation_user
    if operation_user != friend_request.to_user
      errors.add(:operation_user, :invalid)
    end
  end
end
