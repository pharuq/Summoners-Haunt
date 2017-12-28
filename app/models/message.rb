class Message < ApplicationRecord
  default_scope -> { order(created_at: :desc)}
  belongs_to :from_user, class_name: "User"
  belongs_to :to_user, class_name: "User"
  validates :from_user_id, presence: true
  validates :to_user_id, presence: true
  validates :content, presence: true, length: {maximum: 1000}
end
