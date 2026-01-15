class Task < ApplicationRecord
  belongs_to :user

  has_one :outline, dependent: :destroy
  has_many :notes, dependent: :destroy

  # Allo nested attributes for notes
  accepts_nested_attributes_for :notes, allow_destroy: true
  accepts_nested_attributes_for :outline, allow_destroy: true

  # Mandates that at least a title and gen. prompt text must exist
  validates :title, presence: true
  validates :synopsis, presence: true

  # Callback to ensure delimiters '\' are automatically deleted from '\\n' in edited & updated outline
  # :contents field.
  # Printable linefeeds ("\\n") are removed, as these cause linefeeds to appear as standard text which cannot be
  # rendered as a new line by view helpers such as simple_format() & markdown()
  # With the delimiter removed, linefeeds are displayed as line breaks. This avoids the need to use html <br> tags
  # and keeps the text in :contents "clean" just like it is provided by the AI agent response.
  
  # Condietional callback: callback used only if :outline exists; else, a method failure would occur
  before_update :process_outline, if: :outline 
  after_create_commit :broadcast_append_to_tasks

  private

  def broadcast_append_to_tasks
    broadcast_append_to "tasks-stream", target: "id-tasks", partial: "tasks/task", locals: { task: self }
  end

  # :outline model callback, pre-update
  def process_outline
    # call child record custom method
    outline.clean_line_feeds
  end

end