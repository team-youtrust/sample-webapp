本レポジトリは、[株式会社YOUTRUST](https://youtrust.co.jp/)が提供する[キャリアSNS「YOUTRUST」](https://youtrust.jp/)で利用しているRailsのサンプルコードです。

## 起動方法

```
# Railsサーバー起動
$ docker compose up

# DBスキーマファイルの適用
$ docker compose exec app bundle exec rails db:schema:apply

# テスト実行
$ docker compose exec app bundle exec rspec
```

## ディレクトリ構成

### [app/controllers/](https://github.com/team-youtrust/sample-webapp/tree/main/app/controllers)
- HTTPの世界とアプリケーションの世界の境界に立つ層。
- 基本的にUseCase or Queryを呼び出すだけの薄い層。
- 各種IDの暗号化/復号はこの層で行う。

### [app/use_cases/](https://github.com/team-youtrust/sample-webapp/tree/main/app/use_cases)
- 一連の更新系のロジックや通知ジョブなどを組み合わせて呼び出す層。
- 基本的にCommandや通知Jobを呼び出すだけの薄い層。
- DBトランザクション管理や排他制御の責務も持つ。
- a UseCase calls some Commands or a Notification job

### [app/commands/](https://github.com/team-youtrust/sample-webapp/tree/main/app/commands)
- 更新系のドメインロジックの置き場。
- リソース指向ではなくオペレーション指向でロジックを分ける。
    - Model内に色々な操作のロジックを書くのではなく、操作毎にロジックを分けて書く。
    - 例. FriendRequest Model内にsend_friend_requestやaccept_friend_requestのメソッドやバリデーションを書くのではなく、SendFriendRequestCommandやAcceptFriendRequestCommandを用意する。
- a Command calls Models and other Commands

### [app/queries/](https://github.com/team-youtrust/sample-webapp/tree/main/app/queries)
- 参照系のドメインロジックの置き場。
- 母集団取得、フィルター、ソートの責務を負う。
- a Query calls Models and other Queries

### [app/models/notification/](https://github.com/team-youtrust/sample-webapp/tree/main/app/models/notification)
- 通知ロジックの置き場。
- 抽象系クラス
    - 通知Jobから直接呼び出されるクラス。
    - 配信対象の絞り込みや通知送信判定を行い、具体系通知クラスを呼び出す。
    - `app/models/notification/` 直下や `app/models/notification/friend_request/` などの名前空間を切ったディレクトリ直下。
- 具体系クラス
    - メール通知、Push通知、サービス内通知、Slack通知など通知処理の詳細を担うクラス。
    - ここでは配信対象の絞り込みや通知送信判定等は行わない。単に通知を送信するだけ。
- 必ず通知Job（`app/jobs/notification_job.rb`)経由で呼び出す。

## 一覧取得系APIについて
一覧系取得APIのロジックについて、「最初にフィルター＆ソート済みのIDsをすべて返して、あとは各ページごとにIDs指定でリソースを取得する」という方式を採用しています。[参考](https://tech.youtrust.co.jp/entry/thinking-about-scaleable-listing-logic)

そのため取得系APIを下記の2種類に分けています。

- 「フィルター＆ソート処理されたリソースのIDsを返すAPI」
- 「指定IDsのリソースを返すAPI」

## 参考

### 技術ブログ
* [Rails on YOUTRUST ＜ロジックどこ置く？編＞](https://tech.youtrust.co.jp/entry/rails-on-youtrust-class-division)
* [サービス成長に耐えうるリスト取得ロジックについて考える](https://tech.youtrust.co.jp/entry/thinking-about-scaleable-listing-logic)

## 注意事項
* :warning: 本レポジトリはサンプルコードです。Production環境で求められるセキュリティ要件を満たしておらず、認証周りの記述に脆弱性があります。
* :warning: Railsにおけるクラス分割の学習・参考用途に限ってご利用ください。
