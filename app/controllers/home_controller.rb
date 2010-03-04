class HomeController < ApplicationController
  
  def show
    
    # Top Games - Sort by "ranked value" field
    @top_games = Game.all
    
    # New Users
    
    # Recent Ratings
    
  end
  
end