class FriendRequest::SendUseCase
  include UseCase

  attr_reader :operation_user, :to_user, :friend_request

  def run
    command = ApplicationRecord.transaction do
      User.lock_users(operation_user, to_user) # 排他制御のロックを取得
      FriendRequest::CreateCommand.run(from_user: operation_user, to_user: to_user)
    end

    if command && command.success?
      @friend_request = command.friend_request
      enqueue_notification_job
    else
      errors.add(:to_user, :invalid)
    end
  end

  def initialize(operation_user:, to_user:)
    @operation_user = operation_user
    @to_user = to_user
  end

  private

  def enqueue_notification_job
    NotificationJob.perform_later(:send_friend_request, from_user: operation_user, to_user: to_user)
  end
end
