class Public::HomesController < ApplicationController
  def top
    @posts = Post.where(post_status: 2).order(created_at: :desc).limit(4)
  end

  def about
  end
end
