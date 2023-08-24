require 'rails_helper'

RSpec.describe FriendRequest::MarkAsReadUseCase do
  describe '.run' do
    describe '処理内容について' do
      subject { described_class.run(operation_user: operation_user, friend_request: friend_request) }

      let(:operation_user) { create(:user) }
      let(:friend_request) { create(:friend_request, to_user: operation_user  ) }

      before do
        command = instance_double(FriendRequest::MarkAsReadCommand, success?: true)
        allow_to_receive_mocked_run(FriendRequest::MarkAsReadCommand).and_return(command)
      end

      it 'つながり申請既読コマンドを呼び出す' do
        expect(subject.success?).to eq true
        expect(FriendRequest::MarkAsReadCommand)
          .to have_received(:run)
          .with(friend_request: friend_request)
      end
    end

    describe 'バリデーションについて' do
      context '操作者に権限がない場合' do
        subject { described_class.run(operation_user: operation_user, friend_request: friend_request) }

        let(:operation_user) { create(:user) }
        let(:friend_request) { create(:friend_request, to_user: create(:user)) } # `to_user` is not `current_user`

        it '失敗する' do
          expect(subject.success?).to eq false
        end
      end

      context 'つながり申請既読コマンドに失敗した場合' do
        subject { described_class.run(operation_user: operation_user, friend_request: friend_request) }

        let(:operation_user) { create(:user) }
        let(:friend_request) { create(:friend_request) }

        before do
          command = instance_double(FriendRequest::MarkAsReadCommand, success?: false)
          allow_to_receive_mocked_run(FriendRequest::MarkAsReadCommand).and_return(command)
        end

        it '失敗する' do
          expect(subject.success?).to eq false
        end
      end
    end
  end
end
