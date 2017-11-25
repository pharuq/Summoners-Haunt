class CreateCommunityComments < ActiveRecord::Migration[5.1]
  def change
    create_table :community_comments do |t|
      t.references :community_topic, foreign_key: true
      t.references :user, foreign_key: true
      t.text :content

      t.timestamps
    end
    add_index :community_comments, [:community_topic_id, :created_at]
  end

end
