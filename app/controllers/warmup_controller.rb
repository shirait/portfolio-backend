class WarmupController < ApplicationController
  def index
    ActiveRecord::Base.connection.execute("SELECT 1")
    render json: { status: "ok" }
  end
end