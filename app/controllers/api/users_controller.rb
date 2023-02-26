class Api::UsersController < Api::ApplicationController
  before_action :authenticate_user!

  def show
    @users = fetch_users(param_user_ids)
  end

  private

  def fetch_users(ids)
    user_by_id = User.where(id: ids).index_by(&:id)
    @users = ids.map { |id| user_by_id[id] }.compact
  end

  def param_user_ids
    params[:ids].split(',').map { |enc_id| User.decrypt_id(enc_id) }
  end
end
