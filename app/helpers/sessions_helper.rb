# セッションヘルパ
module SessionsHelper
  def login(user)
    session[:user_id] = user.id
  end

  def login?
    !!current_user
  end

  def logout
    session.delete :user_id
    @current_user = nil
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
