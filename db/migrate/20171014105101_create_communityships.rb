class CreateCommunityships < ActiveRecord::Migration[5.1]
  def change
    create_table :communityships do |t|
      t.references :user, foreign_key: true, index: true
      t.references :community, foreign_key: true, index: true

      t.timestamps
    end
    add_index :communityships, [:user_id, :community_id], unique: true
  end
end
