class Admin::TagsearchesController < ApplicationController
  def search
    @word = params[:tag]
    @posts = Post.where(post_status: 2).tag_search(@word)
    render 'tagsearch'
  end
end
