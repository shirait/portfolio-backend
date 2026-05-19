class Task < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  enum :status, { not_started: 0, in_progress: 1, resolved: 2, completed: 3, feedback: 4, rejected: 5 }, validate: true

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 10000 }
  validates :status, presence: true # 値の検証は enum 宣言の「validate: true」オプションで行われる
  validates :user_id, presence: true # 整合性（userが存在するか？）は外部キー制約に任せる

  def update_snapshot
    {
      status: status,
      due_date: due_date&.strftime("%Y-%m-%d"),
      user_id: user_id
    }
  end

  def record_update!(attributes:, comment_content:, user:)
    transaction do
      before_update = update_snapshot

      update!(attributes)
      comments.create!(
        content: comment_content,
        task_update_info: build_task_update_info(before_update),
        user: user
      )
    end

    self
  end

  def build_task_update_info(before_update)
    changes = []
    current_due_date = due_date&.strftime("%Y-%m-%d")

    changes << "ステータス: #{before_update[:status]} → #{status}" if before_update[:status] != status
    changes << "期日: #{before_update[:due_date] || '-'} → #{current_due_date || '-'}" if before_update[:due_date] != current_due_date
    changes << "担当者ID: #{before_update[:user_id]} → #{user_id}" if before_update[:user_id] != user_id

    changes.presence&.join(", ") || "コメントしました"
  end

  scope :search_by_title, ->(title) {
    where("title LIKE ?", "%#{Task.sanitize_sql_like(title)}%") if title.present?
  }

  scope :search_by_status, ->(status) {
    where(status: status) if status.present?
  }

  scope :search_by_due_date_from, ->(due_date_from) {
    where("due_date >= ?", due_date_from.beginning_of_day) if due_date_from.present?
  }

  scope :search_by_due_date_to, ->(due_date_to) {
    where("due_date <= ?", due_date_to.end_of_day) if due_date_to.present?
  }

  scope :search_by_user_id, ->(user_id) {
    where(user_id: user_id) if user_id.present?
  }
end
