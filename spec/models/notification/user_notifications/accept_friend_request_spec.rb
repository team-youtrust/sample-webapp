require 'rails_helper'

RSpec.describe Notification::UserNotifications::AcceptFriendRequest do
  describe '.run' do
    subject { described_class.run(friend_request: friend_request) }

    let(:friend_request) { create(:friend_request) }

    it 'サービス内通知が作成される' do
      expect(subject.user_notification.persisted?).to eq true
      expect(subject.user_notification.user).to eq friend_request.from_user
      expect(subject.user_notification.from_user).to eq friend_request.to_user
      expect(subject.user_notification.notification_type).to eq 'notification_type_become_friend'
      expect(subject.user_notification.is_read).to eq false
      expect(subject.user_notification.body).to eq '{}'
    end
  end
end
