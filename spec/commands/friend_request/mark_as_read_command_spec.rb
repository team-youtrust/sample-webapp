require 'rails_helper'

RSpec.describe FriendRequest::MarkAsReadCommand do
  describe '.run' do
    describe '処理内容について' do
      subject { described_class.run(friend_request: friend_request) }

      let(:friend_request) { create(:friend_request) }

      it '既読にする' do
        expect(subject.success?).to eq true
        expect(subject.friend_request.is_read?).to eq true
      end
    end
  end
end
