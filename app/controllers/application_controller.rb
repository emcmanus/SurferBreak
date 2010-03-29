# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helper classes
  protect_from_forgery
  
  # Require facebook connect for ALL pages
  before_filter :require_connected_user
  
  helper_method :current_user_session, :current_user
  
  # Log filtering
  filter_parameter_logging :password, :password_confirmation
  filter_parameter_logging :fb_sig_friends
  
  private
    # Require Facebook Connect
    def require_connected_user
      unless current_user or self.controller_name == "user_sessions"
        store_location
        flash[:notice] = "Please sign in first!"
        redirect_to login_path
      end
    end
    
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
end
