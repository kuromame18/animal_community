class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, presence: true
  validates :user_name, presence: true

  # ゲストユーザー
  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guest"
      user.user_name = "ゲスト"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end

  # ユーザーステータス
  enum status: { active: 0, withdrawal: 1 }

  # プロフィール画像
  has_one_attached :profile_image

end
