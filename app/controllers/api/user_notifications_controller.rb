class Api::UserNotificationsController < Api::ApplicationController
  before_action :authenticate_user!

  def index
    @user_notification_ids = UserNotification
      .where(user: current_user)
      .order(created_at: :desc)
      .map(&:encrypted_id)
  end

  def show
    @user_notifications = fetch_user_notifications(param_user_notification_ids)
  end

  private

  def fetch_user_notifications(ids)
    user_notification_by_id = UserNotification
      .where(id: ids, user: current_user)
      .preload(:from_user)
      .index_by(&:id)

    ids.map { |id| user_notification_by_id[id] }.compact
  end

  def param_user_notification_ids
    params[:ids].split(',').map { |enc_id| UserNotification.decrypt_id(enc_id) }
  end
end
