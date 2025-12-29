
class TasksController < ApplicationController

  def index
    # Get the radio button parameter (default = all tasks)
    index_type = params[:index_type] || 'default'

    @tasks = case index_type
      when 'default'
        Task.all
      when 'done'
        Task.joins(:outline)
      when 'incomplete'
        Task.select { |m| m.outline.present? == false }
      end
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to tasks_path
    else
      render :new, status: :unprocessable_entity
    end
  end


  private

  # def get_task
  #   @task = Task.find(params[:id])
  # end

  def task_params
    params.require(:task).permit(:title, :synopsis, :notes)
  end

end
