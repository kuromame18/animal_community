class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :ensure_post_owner, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    tag_list = params[:post][:name].split(',')

    # ステータス更新
    if params[:draft].present?
      @post.post_status = :draft
    else
      @post.post_status = :active
    end

     if @post.save
      if @post.draft?
        @post.save_tag(tag_list)
        flash[:notice] = '下書きが保存されました。'
        redirect_to post_path(@post.id)
      else
        @post.save_tag(tag_list)
        flash[:notice] = '投稿が公開されました。'
        redirect_to post_path(@post.id)
      end
    else
      flash[:alert] = '投稿に失敗しました。必要事項を入力して下さい。'
      redirect_to new_post_path
    end
  end

  def index
    @posts = Post.where(post_status: 2).page(params[:page]).per(8)
    @tags = Tag.joins(:posts).group('tags.id').order('COUNT(tags.id) DESC').limit(8)
  end

  def show
    @post = Post.find(params[:id])
    @tags = @post.tags
    @comment = Comment.new
  end

  def edit
    @post = Post.find(params[:id])
    @tag = @post.tags.pluck(:name).join(',')
  end

  def update
    @post = Post.find(params[:id])
    tag = params[:post][:name].split(',')
    @post.user_id = current_user.id

    #下書き機能・属性を追加
    @post.assign_attributes(post_params)

    if params[:draft].present?
      @post.post_status = :draft
      notice_message = "下書きを保存しました。"
      redirect_path = post_path(@post.id)
    elsif params[:inactive].present?
      @post.post_status = :inactive
      notice_message = "非公開にしました。"
      redirect_path = post_path(@post.id)
    else params[:active].present?
      @post.post_status = :active
      notice_message = "公開にしました。"
      redirect_path = post_path(@post.id)
    end

    if @post.update(post_params)
       @post.save_tag(tag)
      redirect_to redirect_path, notice: notice_message
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "投稿の削除に成功しました"
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :post_status, :post_image, :name)
  end

  def ensure_post_owner
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to root_path, alert: "変更はログインしたユーザーのみが可能です。"
    end
  end
end
