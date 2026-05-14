# frozen_string_literal: true

users = User.order(:id).to_a
tasks = Task.where.not(status: Task.statuses[:not_started]).order(:id).to_a

raise "Comment seeds require users. Run db/seeds/development/01users.rb first." if users.empty?
raise "Comment seeds require started tasks. Run db/seeds/development/10tasks.rb first." if tasks.empty?

comment_templates = [
  [ "対応を開始しました。進捗があればこのコメントに追記します。", "status: in_progress" ],
  [ "実装方針を確認しました。現時点では大きな懸念はありません。", "review: checked" ],
  [ "動作確認を行いました。必要に応じて追加確認します。", "test: verified" ]
]

tasks.each_with_index do |task, task_index|
  comment_templates.each_with_index do |(content, task_update_info), comment_index|
    user = users[(task_index + comment_index) % users.length]

    Comment.find_or_create_by!(
      task: task,
      user: user,
      content: content
    ) do |comment|
      comment.task_update_info = task_update_info
    end
  end
end
