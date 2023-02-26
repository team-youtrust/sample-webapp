class Api::FriendRequest::ReceivingController < Api::ApplicationController
  before_action :authenticate_user!

  def index
    @receiving_friend_request_ids = ReceivingFriendRequestsQuery
      .run(operation_user: current_user)
      .map(&:encrypted_id)
  end
end
