class HomeController < ApplicationController
  
  def show
    
    # DO A PERFORMANCE PASS ON THESE QUERIES
    
    # Top Games - Sort by "ranked value" field
    @top_games = Game.all(:order => "created_at DESC", :limit => 10)
    
    # New Users
    @new_users = User.all(:order => "created_at DESC", :limit => 10)
    
    # Recent Ratings
    @new_ratings = Rating.all(:order => "created_at DESC", :limit => 10)
  end
  
end