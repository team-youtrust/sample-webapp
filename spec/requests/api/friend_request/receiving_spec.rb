require 'rails_helper'

RSpec.describe '/api/friend_requests/receiving' do
  describe 'GET /api/friend_requests/receiving' do
    describe '200系' do
      let(:current_user) { create(:user) }
      let(:friend_request1) { create(:friend_request) }
      let(:friend_request2) { create(:friend_request) }

      before do
        sign_in current_user

        allow_to_receive_mocked_run(ReceivingFriendRequestsQuery)
          .and_return([friend_request1, friend_request2])
      end

      it '200' do
        get '/api/receiving_friend_requests'
        expect(response).to have_http_status(:ok)
        expect(response_body).to eq(
          {
            'ids' => [friend_request1.encrypted_id, friend_request2.encrypted_id],
          },
        )
      end
    end

    describe '400系' do
      let(:current_user) { create(:user) }

      it '401' do
        get '/api/receiving_friend_requests'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
