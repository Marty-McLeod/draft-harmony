class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :synopsis
      t.text :assignment_notes
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
