class Diary < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc)}
  has_many :diary_comments, dependent: :destroy

  mount_uploader :pictures, PictureUploader
  serialize :pictures, JSON

  validates :title, presence: true, length: {maximum: 70}
  validates :content, presence: true, length: {maximum: 4000}
  # validate  :picture_size

    private

    # # アップロードされた画像のサイズをバリデーションする
    # def picture_size
    #   if pictures.size > 5.megabytes
    #     errors.add(:picture, "should be less than 5MB")
    #   end
    # end
end
