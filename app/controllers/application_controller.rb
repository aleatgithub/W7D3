class ApplicationController < ActionController::Base
 #these give views access?
  helper_method :current_user, :logged_in?

  def logout
    current_user.reset_session_token!
    session[:session_token] = nil
    @current_user = nil
  end

  def logged_in?
    !!current_user
    #!current_user.nil?
  end

  def current_user
    @current_user ||= User.find_by(session: session[:session_token])
  end

  def login(user)
    session[:session_token] = user.reset_session_token!
  end 
  

  def require_user 
    redirect_to new_user_url if logged_in? 
  end

  
end
