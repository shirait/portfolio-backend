# タスク管理アプリ — システム概要

![Ruby](https://img.shields.io/badge/Ruby-4.0.5-CC342D?logo=ruby&logoColor=white)
![Rails](https://img.shields.io/badge/Rails-8-CC0000?logo=rubyonrails&logoColor=white)
![Next.js](https://img.shields.io/badge/Next.js-16-000000?logo=next.js&logoColor=white)
![React](https://img.shields.io/badge/React-19-61DAFB?logo=react&logoColor=black)
![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?logo=typescript&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?logo=postgresql&logoColor=white)
![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-06B6D4?logo=tailwindcss&logoColor=white)
![Vercel](https://img.shields.io/badge/Vercel-000000?logo=vercel&logoColor=white)
![Render](https://img.shields.io/badge/Render-46E3B7?logo=render&logoColor=black)
![Supabase](https://img.shields.io/badge/Supabase-3FCF8E?logo=supabase&logoColor=black)

フロントエンド（Next.js）とバックエンド（Rails API）で構成されるタスク管理アプリの全体ドキュメントです。

- [フロントエンド](https://github.com/init-tshirai/portfolio-frontend)
- [バックエンド](https://github.com/init-tshirai/portfolio-backend)

---

## 目次

- [タスク管理アプリ — システム概要](#タスク管理アプリ--システム概要)
  - [目次](#目次)
  - [デモ環境](#デモ環境)
  - [工夫した点](#工夫した点)
  - [使用技術](#使用技術)
  - [インフラ構成](#インフラ構成)
  - [認証・認可について](#認証認可について)
  - [ER 図](#er-図)
  - [API 設計](#api-設計)
  - [技術選定理由](#技術選定理由)
    - [フロントエンド](#フロントエンド)
    - [バックエンド](#バックエンド)
    - [リポジトリ構成](#リポジトリ構成)
  - [開発背景・きっかけ](#開発背景きっかけ)
  - [今後の改善点](#今後の改善点)

---

## デモ環境

| 項目 | 内容 |
|------|------|
| URL | https://portfolio-frontend-one-topaz.vercel.app/ |
| メールアドレス | `normal@example.com` |
| パスワード | `faipheiz4ieY` |

ローカル環境のセットアップは、各リポジトリの README を参照してください。

- [フロントエンド README — ローカルセットアップ](https://github.com/init-tshirai/portfolio-frontend#ローカル環境でのセットアップ)
- [バックエンド README — ローカルセットアップ](https://github.com/init-tshirai/portfolio-backend#ローカル環境でのセットアップ)

---

## 工夫した点

- JWT 認証を httpOnly Cookie 経由で扱い、Server Component から安全に API を呼び出す構成としたこと。
- CanCanCan によるロールベースの認可と、画面・API 双方での権限チェックを行っていること。
- Vercel + Render を利用し、デプロイを自動化したこと。

---


## 使用技術

| 区分 | 技術 |
|------|------|
| フロントエンド | Next.js（App Router）, React, TypeScript, Tailwind CSS |
| バックエンド | Rails 8（API モード）, Ruby |
| データベース | PostgreSQL |
| 認証 | Devise + devise-jwt（JWT） |
| 認可 | CanCanCan |
| ホスティング | Vercel（フロント）, Render（API）, Supabase（DB） |

---

## インフラ構成

[infrastructure_architecture.md](./infrastructure_architecture.md)

---

## 認証・認可について

[auth.md](./auth.md)

---

## ER 図

[entity_relationship_diagram.md](./entity_relationship_diagram.md)

---

## API 設計

[api_design.md](./api_design.md)

---

## 技術選定理由

### フロントエンド

| 技術 | 選定理由 |
|------|----------|
| **Next.js（App Router）** | Server Component / Server Action により、認証 Cookie をクライアントに晒さず API を呼び出せる。ファイルベースルーティングで画面構成が直感的。 |
| **TypeScript** | 型による安全性と、API レスポンスとの整合性チェック。 |
| **Tailwind CSS** | ユーティリティファーストでスタイルを素早く組み立てられる。 |

### バックエンド

| 技術 | 選定理由 |
|------|----------|
| **Rails 8（API モード）** | REST API を素早く構築できる。Active Record によるバリデーション・トランザクション等を容易に実装できる。 |
| **PostgreSQL** | 実務でも多く利用される定番の RDB。Render や Supabase といった DB ホスティングサービスと相性が良い。 |
| **Devise + devise-jwt** | API として利用するため JWT を選択。認証の失効は jti で実現。 |
| **CanCanCan** | ロールごとの認可を単一ファイルにシンプルに記述可能で、権限機能を素早く構築することが可能。 |

### リポジトリ構成

フロントエンドとバックエンドは別のGitHubリポジトリで管理しています。<br>
（Twelve-Factor App の「コードベース」に従い、デプロイ単位ごとに1コードベースとし、システム全体のドキュメントはバックエンド側のdocs/ディレクトリに集約しています。）

---

## 開発背景・きっかけ

本アプリは、 Next.js + Rails APIモード によるフロント・バックエンド分離構成を学ぶために制作しました。

---

## 今後の改善点

- タスクのステータス属性の追加
- ~タスク一覧画面へのソート機能の追加~ （追加済み）
- ユーザー管理機能の追加
- 監査ログ（PaperTrail）の追加
- 例外通知機能（Exception Notification）の追加
