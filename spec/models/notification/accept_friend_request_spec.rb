require 'rails_helper'

RSpec.describe Notification::AcceptFriendRequest do
  describe '.run' do
    subject { described_class.run(friend_request: friend_request) }

    let(:friend_request) { create(:friend_request) }

    it 'サービス内通知が送信される' do
      allow_to_receive_mocked_run(Notification::UserNotifications::AcceptFriendRequest)

      subject

      expect(Notification::UserNotifications::AcceptFriendRequest)
        .to have_received(:run)
        .with(friend_request: friend_request)
    end
  end
end
