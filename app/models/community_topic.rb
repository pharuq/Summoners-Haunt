class CommunityTopic < ApplicationRecord
  belongs_to :user
  belongs_to :community
  has_many :community_comments, dependent: :destroy
  validates :title, presence: true, length: {maximum: 70}
  validates :content, presence: true, length: {maximum: 4000}
end
