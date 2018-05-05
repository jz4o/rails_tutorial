# セッションコントローラ
class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: session_params[:email].downcase
    if user&.authenticate session_params[:password]
      login user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path
  end

  private

  def session_params
    params.require(:session).permit %i[email password]
  end
end
