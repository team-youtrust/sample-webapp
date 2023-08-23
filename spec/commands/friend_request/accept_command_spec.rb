require 'rails_helper'

RSpec.describe FriendRequest::AcceptCommand do
  describe '.run' do
    describe '処理内容について' do
      subject { described_class.run(friend_request: friend_request) }

      let(:friend_request) { create(:friend_request) }

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
      context 'つながり申請が保留状態ではない場合' do
        subject { described_class.run(friend_request: friend_request) }

        let(:friend_request) { create(:friend_request, :status_accepted) }

        it '失敗する' do
          expect(subject.success?).to eq false
        end
      end
    end
  end
end
