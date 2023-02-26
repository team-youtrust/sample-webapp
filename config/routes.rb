Rails.application.routes.draw do
  namespace :api, format: 'json' do
    post 'session', to: 'session#create' # ログイン

    # ユーザー関連
    get 'users/:ids', to: 'users#show'
    get 'users/:id/profile', to: 'user_profile#show'
    get 'users/:id/friends', to: 'friends#index'
    get 'search_users', to: 'search_users#index'

    # TODO: サービス内通知関連

    #
    # つながり申請関連
    #
    post 'friend_requests', to: 'friend_request/send#create' # つながり申請の送信
    get 'friend_requests/:ids', to: 'friend_request/friend_requests#show' # 指定IDsのつながり申請を取得
    put 'friend_requests/:id/accept', to: 'friend_request/accept#update' # つながり申請の承認
    put 'friend_requests/:id/mark_as_read', to: 'friend_request/mark_as_read#update' # つながり申請の既読処理
    get 'receiving_friend_requests', to: 'friend_request/receiving#index' # 受信したつながり申請のIDsを取得
    get 'sending_friend_requests', to: 'friend_request/sending#index' # 送信したつながり申請のIDsを取得
    # TODO: 友達削除
    # TODO: つながり申請取り消し
  end
end
