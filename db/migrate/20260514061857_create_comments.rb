class CreateComments < ActiveRecord::Migration[8.1]
  def change
    create_table :comments do |t|
      t.text :content, null: false
      t.references :task, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :task_update_info

      t.timestamps
    end
  end
end
