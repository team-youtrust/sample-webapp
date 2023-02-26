class Notification::SendFriendRequest < Notification::ApplicationNotification
  attr_reader :from_user, :to_user

  # 「つながり申請送信」に関連する各種通知を呼び出すクラス
  def run
    # 例
    # send_push_notification
  end

  private

  def initialize(from_user:, to_user:)
    @from_user = from_user
    @to_user = to_user
  end

  # 例
  # def send_push_notification
  #   Notification::PushNotification::SendFriendRequest.run(from_user: from_user, to_user: to_user)
  # end
end
