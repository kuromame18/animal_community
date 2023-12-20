class Post < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags, dependent: :destroy
  has_many :favorites, dependent: :destroy

  attribute :name, :string

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 300 }

  # 投稿のステータス
  enum post_status: { draft: 0, inactive: 1, active: 2 }

  # 画像の処理
  has_one_attached :post_image

  def get_post_image(width, height)
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      post_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    post_image.variant(resize_to_limit: [width, height]).processed
  end

  # タグの処理
  def save_tag(sent_tags)
    # タグの存在を確認->タグを配列として取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 取得したタグから送られてきたタグを除いたタグ
    old_tags = current_tags - sent_tags
    # 送信されてきたタグから現在存在するタグを除いたタグ
    new_tags = sent_tags - current_tags

    # old_tagを取り出し削除
    old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old)
    end

    # 新しいタグの保存
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      self.tags << new_post_tag
    end
  end

  # いいね機能
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.favorites_posts(user, page, per_page) # モデル内での操作を開始
  includes(:favorites) # favorites テーブルを結合
    .where(favorites: { user_id: user.id }) # ユーザーがいいねしたレコードを絞り込み
    .order(created_at: :desc) # 投稿を作成日時の降順でソート
    .page(page) # ページネーションのため、指定ページに表示するデータを選択
    .per(per_page) # ページごとのデータ数を指定
  end

  # 検索機能
  def self.tag_search(tag)
    joins(:tags).where("tags.name LIKE ?", "%#{tag.downcase}%").order(:created_at)
  end

  # ページネーション
  paginates_per 8
end
