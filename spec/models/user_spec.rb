# == Schema Information
#
# Table name: users
#
#  id         :bigint           unsigned, not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe User do
  describe '#friend_with?' do
    subject { user1.friend_with?(user2) }

    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    context '指定ユーザーと友達である場合' do
      before do
        make_friends(user1, user2)
      end

      it 'true' do
        expect(subject).to eq true
      end
    end

    context '指定ユーザーと友達ではない場合' do
      it 'false' do
        expect(subject).to eq false
      end
    end
  end

  describe '#relationship_with' do
    subject { user1.relationship_with(user2) }

    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    context '指定ユーザーと友達である場合' do
      before do
        make_friends(user1, user2)
      end

      it "'friend'" do
        expect(subject).to eq 'friend'
      end
    end

    context '指定ユーザーにつながり申請を送信している場合' do
      before do
        create(:friend_request, from_user: user1, to_user: user2)
      end

      it "'sending_friend_request'" do
        expect(subject).to eq 'sending_friend_request'
      end
    end

    context '指定ユーザーからつながり申請を受信している場合' do
      before do
        create(:friend_request, from_user: user2, to_user: user1)
      end

      it "'receiving_friend_request'" do
        expect(subject).to eq 'receiving_friend_request'
      end
    end

    context 'その他' do
      it "'other'" do
        expect(subject).to eq 'other'
      end
    end
  end
end
