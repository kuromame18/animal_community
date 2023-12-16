class Public::TagsearchesController < ApplicationController
  def search
    @word = params[:tag]
    @posts = Post.tag_search(@word)
    render 'tagsearch'
  end
end
