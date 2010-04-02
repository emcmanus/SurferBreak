class PublishController < ApplicationController
  
  def show
    # Find all unpublished games for this user, display metadata forms for each
    @unpublished_games = Game.find_unpublished_for current_user
    @unprocessed_games = Game.find_unprocessed_for current_user
  end
  
  def create
    # Receive the form submitted during the publish step
  end
  
end
