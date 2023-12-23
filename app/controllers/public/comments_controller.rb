class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    post = Post.find(params[:post_id])
    comment = current_user.comments.new(comment_params)
    comment.post_id = post.id
    if comment.save
        redirect_to post_path(post)
    else
        flash[:alert] = "コメントに失敗しました。"
        redirect_to post_path(post)
    end
  end

  def destroy
    comment = Comment.find(params[:post_id])
    post = comment.post
    comment.destroy
    redirect_to post_path(post)
  end

private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
