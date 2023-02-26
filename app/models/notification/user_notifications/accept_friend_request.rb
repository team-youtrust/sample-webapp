class Notification::UserNotifications::AcceptFriendRequest < Notification::ApplicationNotification
  attr_reader :friend_request, :user_notification

  def run
    @user_notification = UserNotification.create!(
      user: friend_request.from_user,
      from_user: friend_request.to_user,
      notification_type: :notification_type_become_friend,
      is_read: false,
      body: {}.to_json,
    )
  end

  private

  def initialize(friend_request:)
    @friend_request = friend_request
  end
end
