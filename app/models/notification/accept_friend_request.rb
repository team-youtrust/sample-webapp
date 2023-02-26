class Notification::AcceptFriendRequest < Notification::ApplicationNotification
  attr_reader :friend_request

  # 「つながり申請承認」に関連する各種通知を呼び出すクラス
  def run
    # 例
    # send_push_notification
    #
    # if friend_request.to_user.permits_email_notification?(:accept_friend_request)
    #   send_email_notification
    # end
  end

  private

  def initialize(friend_request:)
    @friend_request = friend_request
  end

  # 例
  # def send_push_notification
  #   Notification::PushNotification::AcceptFriendRequest.run(friend_request: friend_request)
  # end
end
