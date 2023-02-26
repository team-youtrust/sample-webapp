require 'rails_helper'

RSpec.describe FriendRequest::SendUseCase do
  describe '.run' do
    describe '処理内容について' do
      subject { described_class.run(operation_user: operation_user, to_user: to_user) }

      let(:operation_user) { create(:user) }
      let(:to_user) { create(:user) }

      before do
        command = instance_double(FriendRequest::CreateCommand, success?: true)
        allow_to_receive_mocked_run(FriendRequest::CreateCommand).and_return(command)
      end

      it 'つながり申請作成コマンドを呼び出す' do
        expect(subject.success?).to eq true
        expect(FriendRequest::CreateCommand)
          .to have_received(:run)
          .with(from_user: operation_user, to_user: to_user)
      end

      it '通知ジョブをエンキューする' do
        allow_to_receive_mocked_run(Notification::SendFriendRequest)

        perform_enqueued_jobs do
          expect(subject.success?).to eq true
        end

        expect(Notification::SendFriendRequest)
          .to have_received(:run)
          .with(from_user: operation_user, to_user: to_user)
      end
    end

    describe 'バリデーションについて' do
      context 'つながり申請送信コマンドに失敗した場合' do
        subject { described_class.run(operation_user: operation_user, to_user: to_user) }

        let(:operation_user) { create(:user) }
        let(:to_user) { create(:user) }

        before do
          command = instance_double(FriendRequest::CreateCommand, success?: false)
          allow_to_receive_mocked_run(FriendRequest::CreateCommand).and_return(command)
        end

        it '失敗する' do
          expect(subject.success?).to eq false
        end
      end
    end
  end
end
