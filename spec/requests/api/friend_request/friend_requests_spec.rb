require 'rails_helper'

RSpec.describe '/api/friend_requests/:ids' do
  describe 'GET /api/friend_requests/:ids' do
    describe '200系' do
      let(:current_user) { create(:user) }

      let(:from_user1) { create(:user) }
      let(:to_user1) { create(:user) }

      let(:friend_request1) { create(:friend_request, from_user: current_user, to_user: to_user1) }
      let(:friend_request2) { create(:friend_request, from_user: from_user1, to_user: current_user) }
      let(:friend_request3) { create(:friend_request) }

      before do
        sign_in current_user
      end

      it '200' do
        ids = [
          friend_request1.encrypted_id,
          friend_request2.encrypted_id,
          friend_request3.encrypted_id, # 見れない
        ].join(',')

        get "/api/friend_requests/#{ids}"

        expect(response).to have_http_status(:ok)
        expect(response_body).to eq(
          {
            'friend_requests' => [
              {
                'id' => friend_request1.encrypted_id,
                'created_at' => friend_request1.created_at.to_i,
                'from_user' => {
                  'id' => current_user.encrypted_id,
                  'name' => current_user.name,
                },
                'to_user' => {
                  'id' => to_user1.encrypted_id,
                  'name' => to_user1.name,
                },
              },
              {
                'id' => friend_request2.encrypted_id,
                'created_at' => friend_request2.created_at.to_i,
                'from_user' => {
                  'id' => from_user1.encrypted_id,
                  'name' => from_user1.name,
                },
                'to_user' => {
                  'id' => current_user.encrypted_id,
                  'name' => current_user.name,
                },
              },
            ],
          },
        )
      end
    end

    describe '400系' do
      let(:current_user) { create(:user) }

      it '401' do
        get '/api/friend_requests/aaa,bbb'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
