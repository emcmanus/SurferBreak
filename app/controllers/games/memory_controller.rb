class Games::MemoryController < ApplicationController
  
  def show
    @fb_friends = current_user.facebook_user.friends
  end
  
end
