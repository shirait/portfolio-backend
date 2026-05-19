class Api::V1::TasksController < ApplicationController
  load_and_authorize_resource

  DEFAULT_PAGE = 1
  DEFAULT_LIMIT = 20
  MAX_LIMIT = 100

  # before_action :authenticate_user!
  # 認証は load_and_authorize_resource で行う

  rescue_from CanCan::AccessDenied do |exception|
    render(json: { error: "アクセス権限がありません。" }, status: :forbidden)
  end

  def index
    tasks = Task.preload(:user).order(due_date: :desc)
     .search_by_title(params[:title])
     .search_by_status(params[:status])
     .search_by_due_date_from(due_date_from)
     .search_by_due_date_to(due_date_to)
     .search_by_user_id(params[:user_id])

    total_count = tasks.count
    current_page = page_param
    current_limit = limit_param

    set_pagination_headers(total_count, current_page, current_limit)
    tasks = tasks.offset((current_page - 1) * current_limit).limit(current_limit)

    render(
      json: tasks.map { |task|
        as_api_json(task)
      }
    )
  end

  def create
    task = Task.new(task_params)

    if task.save
      render(json: as_api_json(task), status: :created)
    else
      render(json: { errors: task.errors.full_messages }, status: :unprocessable_entity)
    end
  end

  def show
    task = Task.preload(:user, { comments: :user }).find(params[:id])

    render(json: as_api_json(task))
  end

  def update
    @task.record_update!(
      attributes: task_update_params,
      comment_content: comment_content,
      user: current_user
    )

    render(json: as_api_json(Task.preload(:user, { comments: :user }).find(@task.id)))
  rescue ActiveRecord::RecordInvalid => e
    render(json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity)
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy!
    render(json: { message: "Task deleted successfully" }, status: :ok)
  end

  private

  def as_api_json(task)
    {
      id: task.id,
      title: task.title,
      description: task.description,
      status: task.status,
      due_date: task.due_date&.strftime("%Y-%m-%d"),
      user: {
        id: task.user.id,
        name: task.user.name
      },
      comments: task.comments.map { |comment|
        {
          id: comment.id,
          content: comment.content,
          task_update_info: comment.task_update_info,
          created_at: comment.created_at.strftime("%Y-%m-%d %H:%M:%S"),
          user: {
            id: comment.user.id,
            name: comment.user.name
          }
        }
      }
    }
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date, :user_id)
  end

  def task_update_params
    params.require(:task).permit(:status, :due_date, :user_id)
  end

  def comment_content
    params.require(:comment).permit(:content).fetch(:content)
  end

  def set_pagination_headers(total_count, current_page, current_limit)
    response.set_header("X-Total-Count", total_count)
    response.set_header("X-Current-Page", current_page)
    response.set_header("X-Per-Page", current_limit)
    response.set_header("X-Total-Pages", (total_count.to_f / current_limit).ceil)
  end

  def page_param
    positive_integer_param(:page, DEFAULT_PAGE)
  end

  def limit_param
    [ positive_integer_param(:limit, DEFAULT_LIMIT), MAX_LIMIT ].min
  end

  def positive_integer_param(param_name, default_value)
    return default_value if params[param_name].blank?

    value = Integer(params[param_name], exception: false)
    return value if value&.positive?

    raise ActionController::BadRequest, "Invalid #{param_name}: #{params[param_name]}"
  end

  def due_date_from
    return nil if params[:due_date_from].blank?
    Date.iso8601(params[:due_date_from])
  rescue Date::Error
    raise ActionController::BadRequest, "Invalid due_date_from: #{params[:due_date_from]}"
  end

  def due_date_to
    return nil if params[:due_date_to].blank?
    Date.iso8601(params[:due_date_to])
  rescue Date::Error
    raise ActionController::BadRequest, "Invalid due_date_to: #{params[:due_date_to]}"
  end
end
