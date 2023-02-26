require 'rails_helper'

RSpec.describe '/api/friend_requests' do
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
                'status' => 'status_pending',
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
                'status' => 'status_pending',
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

  describe 'POST /api/friend_requests' do
    describe '200系' do
      context 'つながり申請送信が成功した場合' do
        let(:current_user) { create(:user) }
        let(:to_user) { create(:user) }
        let(:friend_request) { create(:friend_request, from_user: current_user, to_user: to_user) }

        before do
          sign_in current_user
        end

        it '201' do
          use_case = instance_double(FriendRequest::SendUseCase, success?: true, friend_request: friend_request)
          allow_to_receive_mocked_run(FriendRequest::SendUseCase).and_return(use_case)

          post '/api/friend_requests', params: { to_user_id: to_user.encrypted_id }
          expect(response).to have_http_status(:created)
          expect(response_body).to eq(
            {
              'friend_request' => {
                'id' => friend_request.encrypted_id,
                'status' => 'status_pending',
                'created_at' => friend_request.created_at.to_i,
                'from_user' => {
                  'id' => friend_request.from_user.encrypted_id,
                  'name' => friend_request.from_user.name,
                },
                'to_user' => {
                  'id' => friend_request.to_user.encrypted_id,
                  'name' => friend_request.to_user.name,
                },
              },
            },
          )
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
