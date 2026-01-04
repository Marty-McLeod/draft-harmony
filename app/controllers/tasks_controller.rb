class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def show
    # @task = Task.find(params[:id])
    @task
    @note = Note.new
  end

  def new
    @task = Task.new
    # Allow adding a Note in the simple_form, not requiring a separate form
    @task.notes.build # Prepare one Note model field in the #new form
    @task.outline.build
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save!
      redirect_to task_path(@task), notice: "✔ Task and note created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @task
    @note = Note.new
    @outline = Outline.new
  end

  def update
    if @task.update(task_params)
      redirect_to task_path(@task)
    else
      render edit_task_path(@task), notice: "✖ Task edit failed"
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
      notes_attributes: [:id, :text],
      outline_attributes: [:id, :contents]
    )
  end

end
