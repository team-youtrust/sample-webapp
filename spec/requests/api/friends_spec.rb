require 'rails_helper'

RSpec.describe '/api/users/:id/friends' do
  describe 'GET /api/users/:id/friends' do
    describe '200系' do
      context '@meを指定した場合' do
        let(:current_user) { create(:user) }

        let(:user1) { create(:user) }
        let(:user2) { create(:user) }

        before do
          sign_in current_user

          make_friends(current_user, user1)
          make_friends(current_user, user2)
        end

        it '200' do
          get '/api/users/@me/friends'

          expect(response).to have_http_status(:ok)
          expect(response_body).to eq(
            {
              'ids' => [user1.encrypted_id, user2.encrypted_id],
            },
          )
        end
      end

      context 'ユーザーIDを指定した場合' do
        let(:current_user) { create(:user) }

        let(:user1) { create(:user) }
        let(:user2) { create(:user) }

        before do
          sign_in current_user

          make_friends(user1, current_user)
          make_friends(user1, user2)
        end

        it '200' do
          get "/api/users/#{user1.encrypted_id}/friends"

          expect(response).to have_http_status(:ok)
          expect(response_body).to eq(
            {
              'ids' => [current_user.encrypted_id, user2.encrypted_id],
            },
          )
        end
      end
    end

    describe '400系' do
      let(:current_user) { create(:user) }

      it '401' do
        get '/api/users/@me/friends'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
