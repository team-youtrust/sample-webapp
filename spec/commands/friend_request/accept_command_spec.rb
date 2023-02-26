require 'rails_helper'

RSpec.describe FriendRequest::AcceptCommand do
  describe '.run' do
    describe '処理内容について' do
      subject { described_class.run(operation_user: operation_user, friend_request: friend_request) }

      let(:operation_user) { create(:user) }
      let(:friend_request) { create(:friend_request, to_user: operation_user) }

      it '承認して友達になる' do
        expect(subject.success?).to eq true
        expect(subject.friend_request.status_accepted?).to eq true

        expect(
          UserFriend.exists?(user: friend_request.from_user, friend_user: friend_request.to_user),
        ).to eq true

        expect(
          UserFriend.exists?(user: friend_request.to_user, friend_user: friend_request.from_user),
        ).to eq true
      end
    end

    describe 'バリデーションについて' do
      context '自分宛てのつながり申請ではない場合' do
        subject { described_class.run(operation_user: operation_user, friend_request: friend_request) }

        let(:operation_user) { create(:user) }
        let(:friend_request) { create(:friend_request) }

        it '失敗する' do
          expect(subject.success?).to eq false
        end
      end

      context 'つながり申請が保留状態ではない場合' do
        subject { described_class.run(operation_user: operation_user, friend_request: friend_request) }

        let(:operation_user) { create(:user) }
        let(:friend_request) { create(:friend_request, :status_accepted, to_user: operation_user) }

        it '失敗する' do
          expect(subject.success?).to eq false
        end
      end
    end
  end
end
