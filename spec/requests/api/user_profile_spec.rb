require 'rails_helper'

RSpec.describe '/api/users/:id/profile' do
  describe 'GET /api/users/:id/profile' do
    describe '200系' do
      context '@meを指定した場合' do
        let(:current_user) { create(:user) }

        before do
          sign_in current_user
        end

        it '200' do
          get '/api/users/@me/profile'

          expect(response).to have_http_status(:ok)
          expect(response_body).to eq(
            {
              'user' => {
                'id' => current_user.encrypted_id,
                'name' => current_user.name,
                'relationship' => 'me',
              },
            },
          )
        end
      end

      context 'ユーザーIDを指定した場合' do
        let(:current_user) { create(:user) }
        let(:user) { create(:user) }

        before do
          sign_in current_user
        end

        it '200' do
          get "/api/users/#{user.encrypted_id}/profile"

          expect(response).to have_http_status(:ok)
          expect(response_body).to eq(
            {
              'user' => {
                'id' => user.encrypted_id,
                'name' => user.name,
                'relationship' => 'other',
              },
            },
          )
        end
      end
    end

    describe '400系' do
      context '未認証の場合' do
        let(:current_user) { create(:user) }

        it '401' do
          get '/api/users/:id/profile'
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context '不正なユーザーIDを指定した場合' do
        let(:current_user) { create(:user) }

        before do
          sign_in current_user
        end

        it '404' do
          get '/api/users/INVALID/profile'
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
