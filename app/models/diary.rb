class Diary < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc)}
  has_many :diary_comments, dependent: :destroy
end
