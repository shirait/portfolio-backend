class Task < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  enum :status, { not_started: 0, in_progress: 1, resolved: 2, completed: 3, feedback: 4, rejected: 5 }

  # todo: validation実装
end
