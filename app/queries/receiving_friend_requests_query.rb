class ReceivingFriendRequestsQuery
  include Query

  attr_reader :operation_user

  def run
    FriendRequest
      .where(to_user: operation_user)
      .where(status: :status_pending)
      .order(created_at: :desc)
  end

  def initialize(operation_user:)
    @operation_user = operation_user
  end
end
