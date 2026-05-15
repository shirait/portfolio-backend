class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    users = User.order(:name, :id)

    render(json: user_options_json(users))
  end

  def options
    users = User.order(:name, :id)

    render(json: user_options_json(users))
  end

  private

  def user_options_json(users)
    users.map { |user|
      {
        id: user.id,
        name: user.name
      }
    }
  end
end
