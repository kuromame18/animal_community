class Public::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
  end

  def mypage
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
end
