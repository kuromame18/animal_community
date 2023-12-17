class Public::FavoritesController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    if current_user
        favorite = current_user.favorites.new(post_id: @post.id)
        favorite.save
    else
      # ゲストユーザーの場合の処理
      flash[:alert] = "ゲストユーザーはお気に入り登録できません。"
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    if current_user
      favorite = current_user.favorites.find_by(post_id: @post.id)
      favorite.destroy
    else
      # ゲストユーザーの場合の処理
      flash[:alert] = "ゲストユーザーはお気に入り解除できません。"
    end
  end
end
