class NotificationJob < ApplicationJob
  queue_as :default

  KLASS_BY_TYPE = {
    send_friend_request: Notification::SendFriendRequest,
    accept_friend_request: Notification::AcceptFriendRequest,
  }.freeze

  def perform(type, **args)
    klass = KLASS_BY_TYPE.fetch(type.to_sym)
    klass.run(**args)
  end
end
