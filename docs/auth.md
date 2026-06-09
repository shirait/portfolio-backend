## 認証・認可について

### 流れ

1. ユーザーがフロントの `/login` からログインする
2. Next.js の Route Handler（`POST /api/auth/login`）が `POST /auth/sign_in` を呼び、返却された JWT を httpOnly Cookie（`access_token`）に保存する
3. 以降、Server Component が Cookie からトークンを取り出し、`Authorization: Bearer <token>` 付きで API をサーバー側から呼ぶ
4. API 側は Devise JWT で認証、CanCanCan で認可する
5. ログアウト時は `DELETE /api/auth/logout` 経由で `DELETE /auth/sign_out` を呼び、Cookie を削除する

#### 全体の流れ（シーケンス図）

```mermaid
sequenceDiagram
  participant Browser as ブラウザ
  participant Client as Client Component<br/>(LoginForm 等)
  participant Route as Route Handler<br/>(/api/auth/*)
  participant SC as Server Component<br/>(tasks/page 等)
  participant Rails as Rails API

  Note over Browser,Rails: ログイン
  Client->>Route: POST /api/auth/login (email, password)
  Route->>Rails: POST /auth/sign_in
  Rails-->>Route: Authorization: Bearer <JWT>
  Route->>Browser: Set-Cookie: access_token (httpOnly)

  Note over Browser,Rails: ページ表示
  Browser->>SC: GET /tasks (Cookie 自動送信)
  SC->>SC: cookies() から JWT 取得
  SC->>Rails: GET /api/v1/tasks (Bearer JWT)
  Rails-->>SC: タスクデータ
  SC-->>Browser: レンダリング済み HTML
```

### ロールと権限（CanCanCan）

| role     | 権限            |
| -------- | ------------- |
| `normal` | `Task` の CRUD |
| `admin`  | すべてのリソースを管理   |
| `viewer` | `Task` の閲覧のみ  |
