# セッションヘルパ
module SessionsHelper
  def login(user, require_remember = '0')
    require_remember == '1' ? remember(user) : forget(user)
    session[:user_id] = user.id
  end

  def login?
    !!current_user
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def logout
    forget current_user
    session.delete :user_id
    @current_user = nil
  end

  def forget(user)
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated? cookies[:remember_token]
        login user
        @current_user = user
      end
    end
    @current_user
  end
end
