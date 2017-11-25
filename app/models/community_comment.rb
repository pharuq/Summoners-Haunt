class CommunityComment < ApplicationRecord
  belongs_to :community
  belongs_to :community_topic
  belongs_to :user
  default_scope -> { order(created_at: :desc)}

end
