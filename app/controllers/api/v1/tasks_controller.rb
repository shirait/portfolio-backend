class Api::V1::TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    # todo: 検索機能実装 （users.nameで検索できるよう、eager_loadに変更する。）
    # todo: ページネーション実装
    tasks = Task.preload(:user).order(:id)

    render(
      json: tasks.map { |task|
        {
          id: task.id,
          title: task.title,
          status: task.status,
          user_id: task.user_id,
          user: {
            name: task.user.name
          }
        }
      }
    )
  end
end
