class Upload::PublishController < ApplicationController
  
  def show
    # Find all unpublished games for this user, display metadata forms for each
    @unpublished_games = Game.find_unpublished_for current_user
    @unprocessed_games = Game.find_unprocessed_for current_user
  end
  
  def create
    # Receive the form submitted during the publish step
    # TODO: Move this to the Game model
    params[:games].each do | game_params |
      game = Game.find_by_url game_params[0]
      if game.try(:user) == current_user
        if game_params[1][:thumbnail_id].to_i > 0
          thumbnail = Thumbnail.find( game_params[1][:thumbnail_id].to_i )
          if thumbnail.game == game
            game.thumbnail = thumbnail
            game.user_has_selected_thumbnail = true
          else
            throw "User does not own thumbnail."
          end
        end
        
        game.title = game_params[1][:title]
        game.description = game_params[1][:description]
        game.file_published = true
        
        game.save
      else
        throw "User does not own game."
      end
    
      # Check for newly processed games
      unpublished_games = Game.find_unpublished_for current_user
      if unpublished_games.try(:length) > 0
        # Set flash and reload upload_publish
        flash[:notice] = "#{unpublished_games.count} more games are ready for publishing."
        redirect_to upload_publish_path and return
      end
      
      # Set flash and redirect to profile
      flash[:notice] = "Games successfully published."
      redirect_to profile_path and return
    end
    throw "No games submitted."
  end
  
end
