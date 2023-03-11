require 'rails_helper'

RSpec.describe FriendRequest::CreateCommand do
  describe '.run' do
    describe '処理内容について' do
      subject { described_class.run(from_user: from_user, to_user: to_user) }

      let(:from_user) { create(:user) }
      let(:to_user) { create(:user) }

      it 'つながり申請を送信する' do
        expect(subject.success?).to eq true
        expect(subject.friend_request.persisted?).to eq true
        expect(subject.friend_request.from_user).to eq from_user
        expect(subject.friend_request.to_user).to eq to_user
        expect(subject.friend_request.status).to eq 'status_pending'
        expect(subject.friend_request.is_read).to eq false
      end
    end

    describe 'バリデーションについて' do
      context '相手が自分自身である場合' do
        subject { described_class.run(from_user: from_user, to_user: to_user) }

        let(:from_user) { create(:user) }
        let(:to_user) { from_user }

        it '失敗する' do
          expect(subject.success?).to eq false
        end
      end

      context '相手が友達である場合' do
        subject { described_class.run(from_user: from_user, to_user: to_user) }

        let(:from_user) { create(:user) }
        let(:to_user) { create(:user) }

        before do
          make_friends(from_user, to_user)
        end

        it '失敗する' do
          expect(subject.success?).to eq false
        end
      end

      context '相手に既に送信済みの場合' do
        subject { described_class.run(from_user: from_user, to_user: to_user) }

        let(:from_user) { create(:user) }
        let(:to_user) { create(:user) }

        before do
          create(:friend_request, from_user: from_user, to_user: to_user)
        end

        it '失敗する' do
          expect(subject.success?).to eq false
        end
      end

      context '相手から既に受信済みの場合' do
        subject { described_class.run(from_user: from_user, to_user: to_user) }

        let(:from_user) { create(:user) }
        let(:to_user) { create(:user) }

        before do
          create(:friend_request, from_user: to_user, to_user: from_user)
        end

        it '失敗する' do
          expect(subject.success?).to eq false
        end
      end
    end
  end
end
