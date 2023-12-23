class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @posts = Post.where(post_status: 2).page(params[:page]).per(8)
    @tags = Tag.joins(:posts).group('tags.id').order('COUNT(tags.id) DESC').limit(8)
  end

  def show
    @post = Post.find(params[:id])
    @tags = @post.tags
  end

  def edit
    @post = Post.find(params[:id])
    @tags = @post.tags
  end

  def update
    @post = Post.find(params[:id])
    # tag = params[:post][:name].split(',')
    # @post.user_id = current_user.id

    #下書き機能・属性を追加
    @post.assign_attributes(post_params)

    if params[:draft].present?
      @post.post_status = :draft
      flash[:notice] = "下書きを保存しました。"
      redirect_path = admin_post_path(@post)
    elsif params[:inactive].present?
      @post.post_status = :inactive
      flash[:notice] = "非公開にしました。"
      redirect_path = admin_post_path(@post)
    else params[:active].present?
      @post.post_status = :active
      flash[:notice] = "公開にしました。"
      redirect_path = admin_post_path(@post)
    end

    if @post.update(post_params)
      redirect_to redirect_path
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "投稿の削除に成功しました"
    redirect_to admin_posts_path
  end

   private

  def post_params
    params.require(:post).permit(:title, :content, :post_status, :post_image, :name)
  end
end
