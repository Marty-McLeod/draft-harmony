class CreateOutlines < ActiveRecord::Migration[7.1]
  def change
    create_table :outlines do |t|
      t.text :contents
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
