class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    tag_list = params[:post][:name].split(',')

    if params[:draft].present?
      @post.post_status = :draft
    else
      @post.post_status = :active
    end

     if @post.save
      if @post.draft?
        @post.save_tag(tag_list)
        redirect_to post_path(@post.id), notice: '下書きが保存されました。'
      else
        @post.save_tag(tag_list)
        redirect_to post_path(@post.id), notice: '投稿が公開されました。'
      end
    else
      render :new
    end
  end

  def index
    post = Post.where(post_status: 2)
    @posts = post.all
    @tags = Tag.all
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

  private

  def post_params
    params.require(:post).permit(:title, :content, :post_status, :post_image)
  end
end
