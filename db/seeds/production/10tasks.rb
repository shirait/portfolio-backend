# frozen_string_literal: true

users = User.where(role: [:normal, :admin]).order(:id).to_a

raise "Task seeds require users. Run db/seeds/development/01users.rb first." if users.empty?

tasks = [
  [ "ポートフォリオのトップページを作成する", "not_started" ],
  [ "ログイン画面のスタイルを調整する", "in_progress" ],
  [ "タスク一覧APIを実装する", "resolved" ],
  [ "タスク一覧画面を作成する", "completed" ],
  [ "プロフィールAPIのレスポンスを確認する", "feedback" ],
  [ "ログアウト処理の動作確認をする", "rejected" ],
  [ "タスク検索の仕様を整理する", "not_started" ],
  [ "ページネーションの方針を検討する", "in_progress" ],
  [ "管理者ユーザーの権限を確認する", "resolved" ],
  [ "READMEに起動手順を追記する", "completed" ],
  [ "seedデータの内容を見直す", "feedback" ],
  [ "エラー表示の文言を調整する", "not_started" ]
]

tasks.each_with_index do |(title, status), index|
  user = users[index % users.length]

  Task.find_or_create_by!(title: title, user: user) do |task|
    task.status = status
    task.description = "#{title}ための開発用タスクです。"
    task.due_date = Date.current + (index + 1).days
  end
end
