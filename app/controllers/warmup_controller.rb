class WarmupController < ApplicationController
  def index
    if authorized?
      ActiveRecord::Base.connection.execute("SELECT 1")
      render json: { status: "ok" }, status: :ok
    else
      render json: { status: "unauthorized" }, status: :unauthorized
    end
  end

  private

  def authorized?
    ActiveSupport::SecurityUtils.secure_compare(
      params[:key].to_s,
      ENV.fetch("WARMUP_SECRET", "")
    )
  end
end