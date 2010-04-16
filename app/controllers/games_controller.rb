class GamesController < ApplicationController
  
  before_filter :require_user, :only => [:new, :edit, :create, :update, :destroy]
  
  # GET /games
  def index
    @games = Game.all
  end
  
  
  # GET /games/1
  def show
    @game = Game.find_by_url(params[:id])
    @thumbnails = Thumbnail.find_all_by_game_id(params[:id])
  end
  

  # GET /games/new
  def new
    @game = Game.new
  end
  

  # GET /games/1/edit
  def edit
    @game = Game.find_by_url(params[:id])
    @thumbnails = Thumbnail.find_all_by_game_id(@game)
  end


  # POST /games
  def create
    @game = Game.new(params[:game])

    respond_to do |format|
      if @game.save
        flash[:notice] = 'Game was successfully created.'
        format.html { redirect_to(@game) }
      else
        format.html { render :action => "new" }
      end
    end
  end


  # PUT /games/1
  def update
    @game = Game.find_by_url(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        flash[:notice] = 'Game was successfully updated.'
        format.html { redirect_to(@game) }
      else
        format.html { render :action => "edit" }
      end
    end
  end


  # DELETE /games/1
  def destroy
    @game = Game.find_by_url(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to(games_url) }
    end
  end
  
end
