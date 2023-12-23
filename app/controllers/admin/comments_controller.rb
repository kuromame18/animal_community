class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!
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
