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
    @task.build_outline
  end

  def create
    @task = current_user.tasks.new(task_params)
    # Assign an empty string to the Outline record contents. This makes view handling & record checking easier,
    # plus we'll always need the field anyhow. Otherwise, the child outline record would be NIL until saved with :contents
    # containing some value (non-empty field)
    @task.outline.contents = ""

    if @task.save!
      broadcast_append_to(@task)
      redirect_to task_path(@task), notice: "✔ Task created successfully"
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
