require 'rails_helper'

RSpec.describe SendingFriendRequestsQuery do
  describe '.run' do
    subject { described_class.run(operation_user: operation_user) }

    let(:operation_user) { create(:user) }

    let(:friend_request1) { create(:friend_request, :status_pending, from_user: operation_user, created_at: 3.day.ago) }
    let(:friend_request2) do
      create(:friend_request, :status_accepted, from_user: operation_user, created_at: 2.day.ago)
    end
    let(:friend_request3) { create(:friend_request, :status_pending, from_user: operation_user, created_at: 1.day.ago) }

    before do
      friend_request1
      friend_request2
      friend_request3
    end

    it '送信した保留状態であるつながり申請を、受信日時が新しい順で返す' do
      expect(subject).to eq [friend_request3, friend_request1]
    end
  end
end
