# タスク管理アプリ（バックエンド）

Rails API です。[フロントエンド（Next.js）](https://github.com/shirait/portfolio-frontend) と組み合わせて利用します。

**システム全体の説明（デモ URL・使用技術・認証・API 設計など）は [docs/system.md](./docs/system.md) を参照してください。**

---

## 目次

- [タスク管理アプリ（バックエンド）](#タスク管理アプリバックエンド)
  - [目次](#目次)
  - [ローカル環境でのセットアップ](#ローカル環境でのセットアップ)
    - [前提](#前提)
    - [手順](#手順)
  - [テスト](#テスト)

---

## ローカル環境でのセットアップ

### 前提

- Ruby 4.0.5 のインストール
- PostgreSQL のインストール
- [portfolio-frontend](https://github.com/shirait/portfolio-frontend) のセットアップおよび起動（`http://localhost:3000`）

### 手順

**bundle install**

```bash
cd (portfolio-backend のディレクトリ)
bundle install
```

**DBセットアップ**

```bash
cp config/database.yml.sample config/database.yml  # 内容はご自身の環境に合わせて適宜修正ください。
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

**credentials に JWT の秘密鍵を追加**

```bash
bin/rails secret  # 出力された文字列をコピーします。
bin/rails credentials:edit  # 「devise_jwt_secret_key: (コピーした文字列)」の行を追加し、エディタを閉じます。
```

**サーバー起動**

```bash
bin/rails server -p 3001
```

ブラウザで http://localhost:3000 を開きます。<br>
以下でログインできたら成功です。<br>
メールアドレス: normal@example.com<br>
パスワード: password

## テスト

```bash
bundle exec rspec
```