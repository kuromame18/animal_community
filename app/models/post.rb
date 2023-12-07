class Post < ApplicationRecord
  belongs_to user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
end
