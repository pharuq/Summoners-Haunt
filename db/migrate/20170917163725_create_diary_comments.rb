class CreateDiaryComments < ActiveRecord::Migration[5.1]
  def change
    create_table :diary_comments do |t|
      t.references :diary, foreign_key: true
      t.references :user, foreign_key: true
      t.text :content

      t.timestamps
    end
    add_index :diary_comments, [:diary_id, :created_at]
  end
end
