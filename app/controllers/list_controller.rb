class ListController < ApplicationController
  
  def show
    @games = Game.all
    @users = User.all
  end
  
end