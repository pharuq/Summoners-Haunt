class Community < ApplicationRecord
  attr_accessor :image_x, :image_y, :image_w, :image_h    # crop用の仮想attribute
  mount_uploader :picture, PictureUploader
  default_scope -> { order(created_at: :desc)}

  belongs_to :user
  has_many :communityships, dependent: :destroy
  has_many :community_members, through: :communityships, source: :user
  has_many :community_topics, dependent: :destroy
  has_many :community_comments, dependent: :destroy

  validates :name, presence: true, length: {maximum: 50}
  validates :content, presence: true, length: {maximum: 4000}
  validate  :picture_size

  # 現在のユーザーが友達であればtrueを返す
  def members?(user)
    community_members.include?(user)
  end

  # ユーザーをコミュニティに入会させる
  def invite(user)
    communityships.create(user_id: user.id)
  end

  # ユーザーをコミュニティから退会させる
  def dismiss(user)
    communityships.find_by(user_id: user.id).destroy
  end

  private

  # アップロードされた画像のサイズをバリデーションする
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
