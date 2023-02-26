class Api::UserProfileController < Api::ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(param_user_id)
  end

  private

  def param_user_id
    params[:id] == '@me' ? current_user.id : User.decrypt_id(params[:id])
  end
end
