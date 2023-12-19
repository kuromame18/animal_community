class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @users = User.all.where(status: 0).page(params[:page]).per(8)
  end
end
