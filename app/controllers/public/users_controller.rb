class Public::UsersController < ApplicationController
  before_action :ensure_guest_user, only: [:edit]
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
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

  private

  def user_params
    params.require(:user).permit(:name,
                                 :email,
                                 :user_name,
                                 :introduction,
                                 :profile_image)
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end
end
