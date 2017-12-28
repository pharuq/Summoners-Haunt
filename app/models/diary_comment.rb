class DiaryComment < ApplicationRecord
  belongs_to :diary
  belongs_to :user
  default_scope -> { order(created_at: :desc)}
  validates :content, presence: true, length: {maximum: 4000}
end
