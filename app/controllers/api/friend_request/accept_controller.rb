class Api::FriendRequest::AcceptController < Api::ApplicationController
  before_action :authenticate_user!

  def update
    friend_request = FriendRequest.find_by_encrypted_id!(params[:id])
    use_case = FriendRequest::AcceptUseCase.run(operation_user: current_user, friend_request: friend_request)

    if use_case.success?
      @friend_request = use_case.friend_request
      render :update, status: :ok
    else
      head :bad_request
    end
  end
end
