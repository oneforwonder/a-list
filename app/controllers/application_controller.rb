# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :current_user
  filter_parameter_logging :password, :password_confirmation
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  private
  
  def require_user
    if !current_user
      store_destination
      redirect_to log_in_path
      flash[:notice] = 'Before you go there, you need to log in.'
    end
  end

  def require_no_user
    if current_user
      redirect_to shares_path
      # TODO: Flash notice?
    end
  end

  def store_destination
    session[:return_to] = request.request_uri
  end

  def redirect_to_destination_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
end
