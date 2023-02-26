require 'rails_helper'

RSpec.describe '/api/user_notifications' do
  describe 'GET /api/user_notifications' do
    describe '200系' do
      let(:current_user) { create(:user) }

      let(:user_notification1) { create(:user_notification, user: current_user) }
      let(:user_notification2) { create(:user_notification, user: current_user) }

      before do
        sign_in current_user

        user_notification1
        user_notification2
      end

      it '200' do
        get '/api/user_notifications'

        expect(response).to have_http_status(:ok)
        expect(response_body).to eq(
          {
            'ids' => [
              user_notification1.encrypted_id,
              user_notification2.encrypted_id,
            ],
          },
        )
      end
    end

    describe '400系' do
      let(:current_user) { create(:user) }

      it '401' do
        get '/api/user_notifications'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/user_notifications/:ids' do
    describe '200系' do
      let(:current_user) { create(:user) }

      let(:user_notification1) { create(:user_notification, user: current_user) }
      let(:user_notification2) { create(:user_notification, user: current_user) }
      let(:user_notification3) { create(:user_notification) }

      before do
        sign_in current_user

        user_notification1
        user_notification2
        user_notification3
      end

      it '200' do
        ids = [
          user_notification1.encrypted_id,
          user_notification2.encrypted_id,
          user_notification3.encrypted_id, # 見れない
        ].join(',')
        get "/api/user_notifications/#{ids}"

        expect(response).to have_http_status(:ok)
        expect(response_body).to eq(
          {
            'user_notifications' => [
              {
                'id' => user_notification1.encrypted_id,
                'notification_type' => 'notification_type_become_friend',
                'body' => {},
                'is_read' => false,
                'created_at' => user_notification1.created_at.to_i,
                'from_user' => {
                  'id' => user_notification1.from_user.encrypted_id,
                  'name' => user_notification1.from_user.name,
                },
              },
              {
                'id' => user_notification2.encrypted_id,
                'notification_type' => 'notification_type_become_friend',
                'body' => {},
                'is_read' => false,
                'created_at' => user_notification2.created_at.to_i,
                'from_user' => {
                  'id' => user_notification2.from_user.encrypted_id,
                  'name' => user_notification2.from_user.name,
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
        get '/api/user_notifications'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
