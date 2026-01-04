class OutlinesController < ApplicationController

  # def new
  #   @outline = Outline.new
  # end

  def create
    @outline = Outline.new(outline_params)
    @outline.task = Task.find(params[:task_id])

    if @outline.save!
      redirect_to task_path(params[:task_id])
    else
      redirect_to task_path(params[:task_id]), status: :see_other, notice: "✖ Outline create failed"
    end
  end

  def destroy
    @outline = Outline.find(params[:id])
    @outline.destroy
    redirect_to task_path(params[:task_id]), status: :see_other
  end

  private

  def outline_params
    params.require(:outline).permit(:contents)
  end

end
