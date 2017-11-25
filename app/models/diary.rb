class Diary < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc)}
  has_many :diary_comments, dependent: :destroy
  validates :title, presence: true, length: {maximum: 50}
  validates :content, presence: true, length: {maximum: 2000}
end
