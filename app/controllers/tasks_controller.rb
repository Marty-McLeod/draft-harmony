class TasksController < ApplicationController
  before_action :set_task, only: [:show, :destroy]

  def index
    @tasks = Task.all
  end

  def show
    # @task = Task.find(params[:id])
    @task
  end

  def new
    @task = Task.new
    # Allow adding a Note in the simple_form, not requiring a separate form
    @task.notes.build # Prepare one Note model field in the #new form
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save!
      redirect_to task_path(@task), notice: "✔ Task and note created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, status: :see_other
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(
      :title, :synopsis,
      notes_attributes: [:text]
    )
  end

  
end
