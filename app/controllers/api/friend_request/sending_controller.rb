class Api::FriendRequest::SendingController < Api::ApplicationController
  before_action :authenticate_user!

  def index
    @sending_friend_request_ids = SendingFriendRequestsQuery
      .run(operation_user: current_user)
      .map(&:encrypted_id)
  end
end
