require 'rails_helper'

RSpec.describe '/api/friend_requests' do
  describe 'POST /api/friend_requests' do
    describe '200系' do
      context 'つながり申請送信が成功した場合' do
        let(:current_user) { create(:user) }
        let(:to_user) { create(:user) }

        before do
          sign_in current_user
        end

        it '201' do
          use_case = instance_double(FriendRequest::SendUseCase, success?: true)
          allow_to_receive_mocked_run(FriendRequest::SendUseCase).and_return(use_case)

          post '/api/friend_requests', params: { to_user_id: to_user.encrypted_id }
          expect(response).to have_http_status(:created)
        end
      end
    end

    describe '4XX系' do
      context '未認証の場合' do
        let(:user) { create(:user) }

        it '401' do
          post '/api/friend_requests'
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context '不正なパラメーターが指定された場合' do
        let(:current_user) { create(:user) }

        before do
          sign_in current_user
        end

        it '404' do
          post '/api/friend_requests', params: { to_user_id: 'dummy_to_user_id' }
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'つながり申請送信が失敗した場合' do
        let(:current_user) { create(:user) }
        let(:to_user) { create(:user) }

        before do
          sign_in current_user
        end

        it '400' do
          use_case = instance_double(FriendRequest::SendUseCase, success?: false)
          allow_to_receive_mocked_run(FriendRequest::SendUseCase).and_return(use_case)

          post '/api/friend_requests', params: { to_user_id: to_user.encrypted_id }
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end
end
