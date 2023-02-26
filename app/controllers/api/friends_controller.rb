class Api::FriendsController < Api::ApplicationController
  before_action :authenticate_user!

  def index
    @user_ids = UserFriend
      .where(user_id: param_user_id)
      .order(created_at: :desc)
      .pluck(:friend_user_id)
      .map { |id| User.encrypt_id(id) }
  end

  private

  def param_user_id
    params[:id] == '@me' ? current_user.id : User.decrypt_id(params[:id])
  end
end
