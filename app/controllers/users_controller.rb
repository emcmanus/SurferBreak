class UsersController < ApplicationController
  
  # Auth constraints
  before_filter :require_no_user, :only => [:new, :create]      # Registration
  before_filter :require_user, :only => [:show, :edit, :update] # "My Profile" Actions
  
  
  def new
    @user = User.new
  end
  
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Registered!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  
  def show
    if params[:id].nil?
      @user = @current_user
    else
      @user = User.find(params[:id])
    end
    @facebook_session = facebook_session
  end
  
  
  def edit
    @user = @current_user
  end
  
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
  
end
