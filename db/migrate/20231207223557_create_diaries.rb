class CreateDiaries < ActiveRecord::Migration[7.0]
  def change
    create_table :diaries do |t|
      t.string :title
      t.text :content
      t.datetime :start_time
      t.references :user, null: false, foreign_key: true
      t.integer :micropost_id

      t.timestamps
    end
    add_index :diaries, [:user_id, :created_at]
  end
end
