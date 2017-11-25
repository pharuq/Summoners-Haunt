class CreateCommunityTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :community_topics do |t|
      t.string :title
      t.text :content
      t.references :user, foreign_key: true
      t.references :community, foreign_key: true

      t.timestamps
    end
  end
end
