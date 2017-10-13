class User < ApplicationRecord
  has_many :diaries, dependent: :destroy
  has_many :diary_comments, dependent: :destroy
  has_many :active_friendships, -> { where activated: true },
                                              class_name:  "Friendship",
                                              foreign_key: "from_user_id",
                                              dependent:   :destroy
  has_many :passive_friendships, -> { where activated: true },
                                              class_name:  "Friendship",
                                              foreign_key: "to_user_id",
                                              dependent:   :destroy
  has_many :active_pending_friendships, -> { where activated: false },
                                              class_name:  "Friendship",
                                              foreign_key: "from_user_id",
                                              dependent:   :destroy
  has_many :passive_pending_friendships, -> { where activated: false },
                                              class_name:  "Friendship",
                                              foreign_key: "to_user_id",
                                              dependent:   :destroy
  has_many :active_friends, through: :active_friendships, source: :to_user
  has_many :passive_friends, through: :passive_friendships, source: :from_user
  has_many :active_pending_friends, through: :active_pending_friendships, source: :to_user
  has_many :passive_pending_friends, through: :passive_pending_friendships, source: :from_user
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
                                                  format: { with: VALID_EMAIL_REGEX},
                                                  uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  mount_uploader :picture, PictureUploader
  validate  :picture_size

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # トークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_send_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_send_at < 2.hours.ago
  end

  # ユーザーのステータスフィードを返す
  def feed
    active_friends_ids = "SELECT to_user_id FROM friendships
                      WHERE from_user_id = :user_id AND activated = :true"
    passive_friends_ids = "SELECT from_user_id FROM friendships
                      WHERE to_user_id = :user_id AND activated = :true"
    Diary.where("user_id IN (#{active_friends_ids})
                      OR user_id IN (#{passive_friends_ids})
                      OR user_id = :user_id", user_id: id, true: true)
  end

  # ユーザーに友達申請を送る
  def follow(other_user)
    active_pending_friendships.create(to_user_id: other_user.id)
  end

  # 友達申請を承認する
  # def follow_accept(other_user)
  #   accept_friendship = passive_friendships.find_by(from_user_id: other_user.id)
  #   accept_friendship.update_attribute(:activated, true)
  # end

  # ユーザーを友達から外す
  # def unfollow(other_user)
  #   if active_friendships.find_by(to_user_id: other_user.id)
  #     active_friendships.find_by(to_user_id: other_user.id).destroy
  #   else
  #     passive_friendships.find_by(from_user_id: other_user.id).destroy
  #   end
  # end

  # 友達を取得する
  def friends
    User.where(id: (active_friends + passive_friends).map{ |user| user.id })
  end

  # 現在のユーザーが友達であればtrueを返す
  def friends?(other_user)
    friends.include?(other_user)
  end

  # 現在のユーザーが承認待ちであればtrueを返す
  def active_pending_friends?(other_user)
    active_pending_friends.include?(other_user)
  end

  # 現在のユーザーから申請中であればtrueを返す
  def passive_pending_friends?(other_user)
    passive_pending_friends.include?(other_user)
  end

  def get_friendship_id(other_user)
    Friendship.where("(from_user_id = :user_id
                          AND to_user_id = :other_id) OR
                            (from_user_id = :other_id
                          AND to_user_id = :user_id)", user_id: id, other_id: other_user)
  end

  # 相手ユーザーとのメッセージを返す
  def messages(other_user)
    Message.where("(from_user_id = :user_id
                          AND to_user_id = :other_id) OR
                            (from_user_id = :other_id
                          AND to_user_id = :user_id)", user_id: id, other_id: other_user.to_i)
  end

  def self.search(search)
    if search
      User.where(['name LIKE ?
                          AND role LIKE ?
                          AND profile LIKE ?',
                          "%#{search[:name]}%",
                          "%#{search[:role]}%",
                          "%#{search[:profile]}%"])
    else
      User.all
    end
  end

  private

  # メールアドレスをすべて小文字にする
  def downcase_email
    self.email = email.downcase
  end

  # 有効化トークンとダイジェストを作成および代入する
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  # アップロードされた画像のサイズをバリデーションする
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
