# セッションコントローラ
class SessionsController < ApplicationController
  def new; end

  def create
    permitted_params = session_params
    user = User.find_by email: permitted_params[:email].downcase
    if user&.authenticate permitted_params[:password]
      login user, permitted_params[:remember_me]
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render :new
    end
  end

  def destroy
    logout if login?
    redirect_to root_path
  end

  private

  def session_params
    params.require(:session).permit %i[email password remember_me]
  end
end
