require 'rails_helper'

RSpec.describe FriendRequest::AcceptUseCase do
  describe '.run' do
    describe '処理内容について' do
      subject { described_class.run(operation_user: operation_user, friend_request: friend_request) }

      let(:operation_user) { create(:user) }
      let(:friend_request) { create(:friend_request) }

      before do
        command = instance_double(FriendRequest::AcceptCommand, success?: true)
        allow_to_receive_mocked_run(FriendRequest::AcceptCommand).and_return(command)
      end

      it 'つながり申請承認コマンドを呼び出す' do
        expect(subject.success?).to eq true
        expect(FriendRequest::AcceptCommand)
          .to have_received(:run)
          .with(operation_user: operation_user, friend_request: friend_request)
      end

      it '通知ジョブをエンキューする' do
        allow_to_receive_mocked_run(Notification::AcceptFriendRequest)

        perform_enqueued_jobs do
          expect(subject.success?).to eq true
        end

        expect(Notification::AcceptFriendRequest)
          .to have_received(:run)
          .with(friend_request: friend_request)
      end
    end

    describe 'バリデーションについて' do
      context 'つながり申請送信コマンドに失敗した場合' do
        subject { described_class.run(operation_user: operation_user, friend_request: friend_request) }

        let(:operation_user) { create(:user) }
        let(:friend_request) { create(:friend_request) }

        before do
          command = instance_double(FriendRequest::AcceptCommand, success?: false)
          allow_to_receive_mocked_run(FriendRequest::AcceptCommand).and_return(command)
        end

        it '失敗する' do
          expect(subject.success?).to eq false
        end
      end
    end
  end
end
