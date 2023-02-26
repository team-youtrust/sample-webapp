class Api::FriendRequest::FriendRequestsController < Api::ApplicationController
  before_action :authenticate_user!

  def show
    @friend_requests = fetch_friend_requests_by(param_ids)
  end

  def create
    to_user = User.find_by_encrypted_id!(params[:to_user_id])
    use_case = FriendRequest::SendUseCase.run(operation_user: current_user, to_user: to_user)

    if use_case.success?
      @friend_request = use_case.friend_request
      render :create, status: :created
    else
      head :bad_request
    end
  end

  private

  def fetch_friend_requests_by(ids)
    friend_request_by_id = FriendRequest
      .where(id: ids)
      .preload(*preload_fields)
      .filter { |friend_request| friend_request.viewable_by?(current_user) }
      .index_by(&:id)

    ids.map { |id| friend_request_by_id[id] }.compact
  end

  def param_ids
    params[:ids].split(',').map { |enc_id| FriendRequest.decrypt_id(enc_id) }
  end

  def preload_fields
    [:from_user, :to_user]
  end
end
