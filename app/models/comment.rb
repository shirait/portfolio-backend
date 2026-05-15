class Comment < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates :task_id, presence: true
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 10000 }
  validates :task_update_info, presence: true, length: { maximum: 10000 }
end
