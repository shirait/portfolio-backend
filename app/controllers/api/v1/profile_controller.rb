class Api::V1::ProfileController < ApplicationController
  before_action :authenticate_user!

  def show
    render(
      json: {
        id: current_user.id,
        name: current_user.name,
        role: current_user.role,
        permissions: {
          tasks: {
            read: can?(:read, Task),
            create: can?(:create, Task),
            update: can?(:update, Task),
            destroy: can?(:destroy, Task),
          }
        }
      }
    )
  end
end
