class UserSessionsController < ApplicationController
  # before_filter :require_no_user, :only => [:new, :create]
  # before_filter :require_user, :only => :destroy
  
  def new
    # @user_session = UserSession.new
  end
  
  def show
    redirect_to login_path
  end
  
  def create
    @user_session = UserSession.new
    if @user_session.save
      flash[:notice] = "You're connected!"
      redirect_back_or_default root_path
    else
      redirect_back_or_default root_path
    end
    
    # Verify connect signature
    
    # Try to find user given the facebook UID
    
    # If no session, show error message, redirect to "new" action
    
    # If successful, redirect back to home
    
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default login_path
  end
end
