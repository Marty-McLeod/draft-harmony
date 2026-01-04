class NotesController < ApplicationController
  # def new
  #   @note = Note.new
  # end

  def create
    @note = Note.new(note_params)
    @note.task = Task.find(params[:task_id])

    if @note.save!
      redirect_to task_path(params[:task_id])
    else
      redirect_to task_path(params[:task_id]), status: :see_other, notice: "✖ Note create failed"
    end
  end

  def destroy
    @note.destroy
    redirect_to task_path(params[:task_id]), status: :see_other
  end

  private

  def note_params
    params.require(:note).permit(:text)
  end
  
end
