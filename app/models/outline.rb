class Outline < ApplicationRecord
  belongs_to :task

  # Callback method from parent Task to strip out '\' delimeters automatically being
  # added in the text field in the form.
  # This is call when the parent Task model (via #edit) is updating.
  def clean_line_feeds
    self.contents = self.contents.gsub("\\n", "\n")
  end
end
