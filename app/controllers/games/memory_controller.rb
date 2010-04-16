class Games::MemoryController < ApplicationController
  
  # Need FB Friends
  before_filter :require_user, :only => [:show]
  
  def show
    @fb_friends = current_user.facebook_user.friends
  end
  
end
