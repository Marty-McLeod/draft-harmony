class RemoveAssignmentNotesFromTasks < ActiveRecord::Migration[7.1]
  def change
    remove_column :tasks, :assignment_notes, :text
  end
end
