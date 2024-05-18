## Cloud Tasksを使ってBackground Jobを( Rails + ) Web I/Oで

## 技術スタック

 * Google Cloud Run
 * Google Cloud Storage + FUSE
 * Google Cloud Tasks
 * Ruby on Rails 7.1.3
 * Cloudtasker 0.13.2

## 実現したこと

Rails on Rails + ActiveJob + Cloud Tasks で

 * 追加のデータベーススキーマなし
 * 追加のコンピューティングリソース（ワーカーインスタンス）は待機なし、従量のみ（いわゆるサーバレス）

で非同期バックグラウンドジョブを実行する

## Cloud Tasksを利用するメリット

以下の課題を解決できる。

 * ActiveJob バックエンドを inline や async にするとスケールアウトに対応できない
 * バックグラウンドジョブキューを素朴に実現すると 24h 待機するインスタンスを増やさなくてはならない
 * SolidQueue + puma plugin を利用すれば同一インスタンスで処理できるが、Rails 7.1 以降が必要

## なぜCloudtaskerか

### 選択肢

 * [keypup\-io/cloudtasker: Background jobs for Ruby using Google Cloud Tasks](https://github.com/keypup-io/cloudtasker)
 * [esminc/activejob\-google\_cloud\_tasks\-http: Active Job adapter for Google Cloud Tasks HTTP targets](https://github.com/esminc/activejob-google_cloud_tasks-http)
 * [aertje/cloud\-tasks\-emulator: Google cloud tasks emulator](https://github.com/aertje/cloud-tasks-emulator)

### Google Cloud Tasks Ruby Clientの制限

 * [google\-cloud\-ruby/google\-cloud\-tasks at main · googleapis/google\-cloud\-ruby](https://github.com/googleapis/google-cloud-ruby/tree/main/google-cloud-tasks)
 * [Ruby client library  \|  Google Cloud](https://cloud.google.com/ruby/docs/reference/google-cloud-tasks-v2/latest)

当初はよりシンプルな構成の activejob-google_cloud_tasks-http で行こうと思っていた。しかし local で利用する方法がなく、何か異なる adapter に差し替える必要があった。

その後

[aertje/cloud\-tasks\-emulator: Google cloud tasks emulator](https://github.com/aertje/cloud-tasks-emulator)

を見つけたのでこれで emulator に投げることにすればよいのではないかと考えたが、この emulator の README に書かれていないように Ruby の Google Cloud Tasks client ライブラリから接続先を適切に emulator に向けることがとても難しい[^1]。

それで adapter の差し替えではなく backend の差し替えをシームレスに行って development 環境では Redis を利用して専用の worker を動かす Cloudtasker を利用することとした。

[^1]: entrypoint を localhost の emulator に向けることはできたが、2024-05-18 現在、SSL/TLS の version が違うので handshake に失敗するエラーが出て、そこから先に進めなかった。他の言語では insecure な channel を作ることができているようなのだが、Ruby 版にはどうにもそんなクチを見つけることができなかった。
