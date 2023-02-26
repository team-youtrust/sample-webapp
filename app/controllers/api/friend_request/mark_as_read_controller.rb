class Api::FriendRequest::MarkAsReadController < Api::ApplicationController
  before_action :authenticate_user!

  def update
    friend_request = FriendRequest.find_by_encrypted_id!(params[:id])
    result = FriendRequest::MarkAsReadUseCase.run(operation_user: current_user, friend_request: friend_request)

    if result.success?
      head :ok
    else
      head :bad_request
    end
  end
end
