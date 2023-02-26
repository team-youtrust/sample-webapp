Rails.application.routes.draw do
  namespace :api, format: 'json' do
    post 'session', to: 'session#create' # ログイン

    ##########
    #
    # ユーザー関連
    #
    ##########

    # [ids] 検索結果のユーザーIDsを取得
    get 'search_users', to: 'search_users#index'

    # [resources] リスト用ユーザー情報をIDs指定でリソース取得
    # （検索結果画面や友達一覧画面の両方で利用される）
    get 'users/:ids', to: 'users#show'

    # [resource] プロフィール用ユーザー情報をID指定でリソース取得
    get 'users/:id/profile', to: 'user_profile#show'

    # [ids] 指定IDユーザーの友達IDsを取得
    get 'users/:id/friends', to: 'friends#index'

    ##########
    #
    # サービス内通知
    #
    ##########

    # [ids]
    get 'user_notifications', to: 'user_notifications#index'

    # [resources]
    get 'user_notifications/:ids', to: 'user_notifications#show'

    ##########
    #
    # つながり申請関連
    #
    ##########

    # つながり申請の送信
    post 'friend_requests', to: 'friend_request/friend_requests#create'

    # [resources] 指定IDsのつながり申請リソースを取得
    get 'friend_requests/:ids', to: 'friend_request/friend_requests#show'

    # つながり申請の承認
    put 'friend_requests/:id/accept', to: 'friend_request/accept#update'

    # つながり申請の既読処理
    put 'friend_requests/:id/mark_as_read', to: 'friend_request/mark_as_read#update'

    # [ids] 受信したつながり申請のIDsを取得
    get 'receiving_friend_requests', to: 'friend_request/receiving#index'

    # [ids] 送信したつながり申請のIDsを取得
    get 'sending_friend_requests', to: 'friend_request/sending#index'
  end
end
