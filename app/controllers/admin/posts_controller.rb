class Admin::PostsController < ApplicationController
  def index
    @posts = Post.where(post_status: 2).page(params[:page]).per(8)
    @tags = Tag.joins(:posts).group('tags.id').order('COUNT(tags.id) DESC').limit(8)
  end

  def show
    @post = Post.find(params[:id])
    @tags = @post.tags
  end
end
