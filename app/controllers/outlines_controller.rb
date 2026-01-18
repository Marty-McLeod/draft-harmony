class OutlinesController < ApplicationController

  SYSTEM_PROMPT_PREPEND =  "You are an English composition instructor. I am a college student with an essay writing assignment. "
  SYSTEM_PROMPT_APPEND = "Output format is Markdown only for the response."


  def initialize
    @chat = RubyLLM.chat
  end

  def create
    @outline = Outline.new(outline_params)
    @outline.task = Task.find(params[:task_id])

    if @outline.save
      redirect_to task_path(params[:task_id])
    else
      redirect_to task_path(params[:task_id]), status: :see_other, notice: "✖ Outline create failed"
    end
  end

  def destroy
    @outline = Outline.find(params[:id])

    # @outline.destroy
    # Replace destroy with an empty string to "delete" the current outline
    @outline.contents = ""
    if @outline.save
      redirect_to task_path(params[:task_id]), status: :see_other, note: "✔ Task deleted"
    else
      redirect_to task_path(params[:task_id]), status: :see_other, note: "✖ Delete outline failed"
    end
  end

  def generate
    @task = Task.find(params[:task_id])
    @outline = Outline.find(params[:id])
    @outline.task = @task

    # if !@task.outline.present?
    #   @outline = Outline.new
    #   @outline.task = @task
    # end
    build_system_prompt
    # prompt = "#{SYSTEM_PROMPT_PREPEND} #{@task.synopsis} #{SYSTEM_PROMPT_APPEND}"
    response = @chat.ask(@system_prompt)

    # If it exists, strip out leading & trailing Markdown backticks which may appear from the ChatGPT chat model
    @outline.contents = clean_line_feeds(response.content)

    if @outline.save
      redirect_to task_path(params[:task_id])
    else
      redirect_to task_path(params[:task_id]), status: :see_other, notice: "✖ Outline gen. failed"
    end
  end

  def build_system_prompt
    # Using user options, build the system prompt to be use for a chat agent response request (API)
    user_directive = @task.synopsis
    # sanitize/strip user text as needed here!
    user_directive = user_directive.gsub("\n", "")
    @system_prompt = prompt = "#{SYSTEM_PROMPT_PREPEND} #{user_directive} #{SYSTEM_PROMPT_APPEND}"
  end


  private

  def outline_params
    params.require(:outline).permit(:contents)
  end

  # Strips out extraneous characters which cause issues rendering Markdown text in the view via the
  # view helper. 1) Removes AI agent's insertiong of "Outline: " (trailing whitespace is 0 or more),
  # 2) Trailsing/leading "```" triple backticks which cause erroneous display of all text as a code block,
  # 3) backslash added after an edit/save in the text field. This causes the HTML line breaks to fail and line returns
  # are displayed as "\n" literally., 4) "markdown" text may exist in OpenAI output.
  # 
  def clean_line_feeds(text)
    text = text.gsub(/\A\`{3}|\`{3}\z/, '').gsub("markdown", '')    
    text = text.gsub(/\A(\n)/, '') # Removing leading '\n', if present, and retain
    text = text.gsub(/\A((# Outline: )|(# Outline for )|(# Outline of ))/, '# ')
    text = text.gsub("\\n", "\n")
  end

end
