# タスク管理アプリ（バックエンド）

## 概要

タスク管理アプリのバックエンド(Rails API)です。<br>
[フロントエンド（Next.js）](https://github.com/init-tshirai/portfolio-frontend) と組み合わせて利用します。

URL: https://portfolio-frontend-self-psi.vercel.app/ <br>
ログイン情報<br>
メールアドレス: `normal@example.com` <br>
パスワード: `faipheiz4ieY`

---

## 目次

- [タスク管理アプリ（バックエンド）](#タスク管理アプリバックエンド)
  - [概要](#概要)
  - [目次](#目次)
  - [使用技術](#使用技術)
  - [インフラ構成](#インフラ構成)
  - [認証・認可について](#認証認可について)
  - [ER 図](#er-図)
  - [API 設計](#api-設計)
  - [技術選定理由](#技術選定理由)
  - [ローカル環境でのセットアップ](#ローカル環境でのセットアップ)
    - [前提](#前提)
    - [手順](#手順)
  - [テスト](#テスト)
  - [最後に](#最後に)

---

## 使用技術

[使用技術](https://github.com/init-tshirai/portfolio-frontend/#%E4%BD%BF%E7%94%A8%E6%8A%80%E8%A1%93)

---

## インフラ構成

[インフラ構成](https://github.com/init-tshirai/portfolio-backend/blob/master/docs/infrastructure_architecture.md)

## 認証・認可について

[認証・認可について](https://github.com/init-tshirai/portfolio-backend/blob/master/docs/auth.md)

---

## ER 図

[ER図](https://github.com/init-tshirai/portfolio-backend/blob/master/docs/entity_relationship_diagram.md)

---

## API 設計

[API設計](https://github.com/init-tshirai/portfolio-backend/blob/master/docs/api_design.md)

---

## 技術選定理由

| 技術 | 選定理由 |
| ----------------------- | ---------------------------------------------------------------------- |
| **Rails 8（API モード）** | REST API を素早く構築できる。優秀なORマッパーであるActive Recordが利用でき、バリデーション・トランザクション等を容易に実装できる。ドキュメントも豊富。 |
| **PostgreSQL**            | 実務でも多く利用される定番のRDB。RenderやSupabaseといったDBのホスティングサービスと相性が良く、サイトの外部公開が容易。 |
| **Devise + devise-jwt**   | APIとして利用するため、将来的にスケールできるようJWTを選択。（認証の失効はjtiで実現。） |
| **CanCanCan**             | ロールごとの認可をシンプルに記述可能 |

---

## ローカル環境でのセットアップ

### 前提

- Ruby3.4.9のインストール
- PostgreSQLのインストール
- [portfolio-frontend](https://github.com/init-tshirai/portfolio-frontend) のセットアップおよび起動（`http://localhost:3000`）

### 手順

※先頭の$マークは一般ユーザーで操作することを意味します。コマンドには含めないでください。

bundle install
```bash
$ cd (portfolio-backend のディレクトリ)
$ bundle install
```

DBセットアップ
```bash
$ cp config/database.yml.sample config/database.yml # 内容はご自身の環境に合わせて適宜修正ください。
$ bin/rails db:create
$ bin/rails db:migrate
$ bin/rails db:seed
```

credentials に jwtの秘密鍵追加
```bash
$ bin/rails secret # 出力された文字列をコピーします。
$ bin/rails credentials:edit # 「devise_jwt_secret_key: (コピーした文字列)」の行を追加し、エディタを閉じます。
```

サーバー起動
```bash
$ bin/rails server -p 3001
```

ブラウザで `http://localhost:3000` を開きます。

以下でログインに成功したら成功です。<br>
メールアドレス: normal@example.com<br>
パスワード: password

---

## テスト

※先頭の$マークは一般ユーザーで操作することを意味します。コマンドには含めないでください。

```bash
$ bundle exec rspec
```

---

## 最後に

[「最後に」](https://github.com/init-tshirai/portfolio-frontend/#%E6%9C%80%E5%BE%8C%E3%81%AB)
