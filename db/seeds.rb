# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
begin
Admin.create!(
   email: 'admin@admin',
   password: 'adminadmin'
)

olivia = User.find_or_create_by!(email: "olivia@example.com") do |user|
  user.name = "Olivia"
  user.user_name = "Olivia"
  user.introduction = "猫が好きです。猫に関する投稿をどんどん上げていきます。猫が好きな方、これから一緒に住みたいなと考えている方の役に立つ情報も発信したいと考えています。よろしくお願いします！"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/christopher-campbell-rDEOVtE7vOs-unsplash.jpg"), filename:"christopher-campbell-rDEOVtE7vOs-unsplash.jpg")
end

james = User.find_or_create_by!(email: "james@example.com") do |user|
  user.name = "James"
  user.user_name = "James"
  user.introduction = "犬が好きです。犬に関する投稿をどんどん上げていきます。犬が好きな方、これから一緒に住みたいなと考えている方の役に立つ情報も発信したいと考えています。よろしくお願いします！"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/jonas-kakaroto-mjRwhvqEC0U-unsplash.jpg"), filename:"jonas-kakaroto-mjRwhvqEC0U-unsplash.jpg")
end

lucas = User.find_or_create_by!(email: "lucas@example.com") do |user|
  user.name = "Lucas"
  user.user_name = "Lucas"
  user.introduction = "鳥が好きです。鳥に関する投稿をどんどん上げていきます。鳥が好きな方、これから一緒に住みたいなと考えている方の役に立つ情報も発信したいと考えています。よろしくお願いします！"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sergio-de-paula-c_GmwfHBDzk-unsplash.jpg"), filename:"sergio-de-paula-c_GmwfHBDzk-unsplash.jpg")
end

Post.find_or_create_by!(title: "Cat") do |post|
  post.post_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/manja-vitolic-gKXKBY-C-Dk-unsplash.jpg"), filename:"manja-vitolic-gKXKBY-C-Dk-unsplash.jpg")
  post.content = "我が家の可愛い猫です！のんびりとした性格で毎日とても癒されます！"
  post.name = "猫"
  post.user = olivia
end

Post.find_or_create_by!(title: "Dog") do |post|
  post.post_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/milli-2l0CWTpcChI-unsplash.jpg"), filename:"milli-2l0CWTpcChI-unsplash.jpg")
  post.content = "我が家の可愛い犬です！のんびりとした性格で毎日とても癒されます！"
  post.name = "犬"
  post.user = james
end

Post.find_or_create_by!(title: "Bird") do |post|
  post.post_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/elizabeth-r-5WRBRUsTqPk-unsplash.jpg"), filename:"elizabeth-r-5WRBRUsTqPk-unsplash.jpg")
  post.content = "我が家の可愛い鳥です！のんびりとした性格で毎日とても癒されます！"
  post.name = "鳥"
  post.user = lucas
end

rescue ActiveRecord::RecordInvalid => e
  puts e.record.errors.full_messages
end
