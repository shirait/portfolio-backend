class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    users = User.order(:name, :id)

    render(
      json: users.map { |user|
        {
          id: user.id,
          name: user.name
        }
      }
    )
  end
end
