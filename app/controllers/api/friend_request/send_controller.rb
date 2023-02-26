class Api::FriendRequest::SendController < Api::ApplicationController
  before_action :authenticate_user!

  def create
    to_user = User.find_by_encrypted_id!(params[:to_user_id])
    result = FriendRequest::SendUseCase.run(operation_user: current_user, to_user: to_user)

    if result.success?
      head :created
    else
      head :bad_request
    end
  end
end
