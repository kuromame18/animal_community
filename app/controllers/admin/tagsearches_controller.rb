class Admin::TagsearchesController < ApplicationController
  def search
    @keyword = params[:keyword]
    @tag = params[:tag]

    if @keyword.present? && @tag.present?
      # キーワードとタグの両方で検索
      @posts = Post.where(post_status: 2).keyword_search(@keyword).tag_search(@tag)
      @word = "#{@keyword} and #{@tag}"
    elsif @keyword.present?
      # キーワードのみで検索
      @posts = Post.where(post_status: 2).keyword_search(@keyword)
      @word = @keyword
    elsif @tag.present?
      # タグのみで検索
      @posts = Post.where(post_status: 2).tag_search(@tag)
      @word = @tag
    else
      # どちらも指定されていない場合は全ての投稿を表示
      @posts = Post.where(post_status: 2)
      @word = "All Posts"
    end
    render 'tagsearch'
  end
end
