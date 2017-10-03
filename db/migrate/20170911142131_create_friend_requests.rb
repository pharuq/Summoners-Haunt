class CreateFriendRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :friend_requests do |t|
      t.integer :from_request_user_id
      t.integer :to_request_user_id

      t.timestamps
    end
    add_index :friend_requests, :from_request_user_id
    add_index :friend_requests, :to_request_user_id
    add_index :friend_requests, [:from_request_user_id, :to_request_user_id], unique: true,
    :name => 'requests_index'
  end
end
