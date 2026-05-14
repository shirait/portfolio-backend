class Comment < ApplicationRecord
  belongs_to :task
  belongs_to :user

  # todo: validation実装
end
