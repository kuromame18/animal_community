class Public::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :ensure_guest_user, only: [:edit]
  def index
    @users = User.all.where(status: 0).page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.where(post_status: 2).page(params[:page]).per(8)
  end

  def inactive
    @user = current_user
    @posts = @user.posts.where(post_status: 1).page(params[:page]).per(8)
  end

  def draft
    @user = current_user
    @posts = @user.posts.where(post_status: 0).page(params[:page]).per(8)
  end

  def mypage
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(user_params)
    redirect_to users_mypage_path
  end

  def favorites_posts
    @favorites_posts = Post.favorites_posts(current_user, params[:page], 8)
  end

  private

  def user_params
    params.require(:user).permit(:name,
                                 :email,
                                 :user_name,
                                 :introduction,
                                 :profile_image)
  end

  def ensure_guest_user
    @user = current_user
    if @user.guest_user?
      notice[:alert] = "ゲストユーザーはプロフィール編集画面へ遷移できません。"
      redirect_to user_mypage_path
    end
  end
end
