class Api::V1::TasksController < ApplicationController
  DEFAULT_PAGE = 1
  DEFAULT_LIMIT = 20
  MAX_LIMIT = 100

  before_action :authenticate_user!

  def index
    tasks = search_tasks(Task.preload(:user).order(due_date: :desc))
    total_count = tasks.count
    current_page = page_param
    current_limit = limit_param

    set_pagination_headers(total_count, current_page, current_limit)
    tasks = tasks.offset((current_page - 1) * current_limit).limit(current_limit)

    render(
      json: tasks.map { |task|
        task_json(task)
      }
    )
  end

  def create
    task = Task.create!(task_params)

    render(json: task_json(task), status: :created)
  end

  def show
    task = Task.preload(:user, {comments: :user}).find(params[:id])

    render(json: task_json(task))
  end

  private

  def task_json(task)
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

  def search_tasks(tasks)
    tasks = tasks.where("title LIKE ?", "%#{Task.sanitize_sql_like(params[:title])}%") if params[:title].present?
    tasks = tasks.where(status: status_param) if params[:status].present?
    tasks = tasks.where("due_date >= ?", due_date_from.beginning_of_day) if params[:due_date_from].present?
    tasks = tasks.where("due_date <= ?", due_date_to.end_of_day) if params[:due_date_to].present?
    tasks = tasks.where(user_id: params[:user_id]) if params[:user_id].present?

    tasks
  end

  def status_param
    status = params[:status]
    return status if Task.statuses.key?(status)

    raise ActionController::BadRequest, "Invalid status: #{status}"
  end

  def due_date_from
    Date.iso8601(params[:due_date_from])
  rescue Date::Error
    raise ActionController::BadRequest, "Invalid due_date_from: #{params[:due_date_from]}"
  end

  def due_date_to
    Date.iso8601(params[:due_date_to])
  rescue Date::Error
    raise ActionController::BadRequest, "Invalid due_date_to: #{params[:due_date_to]}"
  end
end
