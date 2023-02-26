require 'rails_helper'

RSpec.describe '/api/search_users' do
  describe 'GET /api/search_users' do
    describe '200系' do
      let(:current_user) { create(:user) }

      let(:user1) { create(:user) }
      let(:user2) { create(:user) }

      before do
        sign_in current_user

        user1
        user2
      end

      it '200' do
        get '/api/search_users'

        expect(response).to have_http_status(:ok)
        expect(response_body).to eq(
          {
            'ids' => [user1.encrypted_id, user2.encrypted_id],
          },
        )
      end
    end

    describe '400系' do
      let(:current_user) { create(:user) }

      it '401' do
        get '/api/search_users'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
