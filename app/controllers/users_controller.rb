# ユーザコントローラ
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      login @user
      flash[:success] = 'Welcome to the Sample App!'
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    permited_columns = %i[name email password password_confirmation]
    params.require(:user).permit permited_columns
  end
end
