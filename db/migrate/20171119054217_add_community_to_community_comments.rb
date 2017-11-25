class AddCommunityToCommunityComments < ActiveRecord::Migration[5.1]
  def change
    add_reference :community_comments, :community, foreign_key: true
  end
end
