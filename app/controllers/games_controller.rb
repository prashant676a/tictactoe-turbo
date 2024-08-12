class GamesController < ApplicationController
  include ActionView::RecordIdentifier
  
  before_action :authenticate_user!
  before_action :set_game, only: [:show, :update, :move,:restart]
  before_action :ensure_joined, only: [:show]


  def index
  end

  def new
    @game = Game.new
  end

  def restart
    Current.user = current_user
    if @game.reset
      respond_to do |format|
        format.html { redirect_to @game}
      end
      broadcast_game_update(@game)
    else
      redirect_to @game, alert: 'Failed to reset the game.'
    end
  end
  

  def create
    @game = Game.new(game_params)
    @game.creator = current_user
    @game.current_symbol = @game.creator_symbol

    if @game.save
      redirect_to @game
    else
      render :new
    end
  end

  def show
    Current.user = current_user
    #can make directly user can visit with link in this page(if only creator exists implement join method here)
  end

  def play
    #to implement random player's match making
    
    #check any games where creator is only present but not joiner (use .last for latest ones)
    #or can add status field in game model to check if atleast one player is on the game and when 0 players are status:inactive
    
    #if above condition is not met create game and wait for other players to join
    
    #whichever is the case need to render/ redirect_to show page 
    #but don't show to url to share instead wait for 30 seconds and 
  end

  def join
    if params[:game_id].present?
      game_id = params[:game_id].split('/').last
      @game = Game.find_by(slug: game_id)
      if @game && @game.joiner.nil? && @game.creator != current_user
        @game.joiner = current_user
        @game.joiner_symbol = @game.creator_symbol == "X" ? "O" : "X"

        if @game.save
          Current.user = current_user
          respond_to do |format|
            format.html { redirect_to @game }
          end
          broadcast_game_update(@game)
        else
          redirect_to games_path, alert: 'Failed to join the game.'
        end
      else
        redirect_to games_path, alert: 'Invalid game URL or already joined.'
      end
    else
      redirect_to games_path, alert: 'Please enter a valid game URL.'
    end
  end

  def update
    Current.user = current_user

    if @game.update(game_params)
      respond_to do |format|
        format.html { redirect_to @game }
      end
      broadcast_game_update(@game)
    end

  end

  def move
    
    row = params[:row].to_i
    col = params[:col].to_i

    if @game.move!(row, col)
      Current.user = current_user
      broadcast_game_update(@game)

      respond_to do |format|
        format.html{redirect_to @game}
      end

    else
      redirect_to @game, alert: 'Invalid move.'
    end

    
  end

  private

  def set_game
    @game = Game.find_by_slug(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to games_path, alert: 'Game not found.'
  end

  def game_params
    params.require(:game).permit(:creator_id, :joiner_id, :creator_symbol, :joiner_symbol, :state, :current_symbol)
  end
  
  def broadcast_game_update(game)
    Turbo::StreamsChannel.broadcast_replace_to(
      game,
      target: dom_id(game),
      partial: 'games/game',
      locals: { game: game, user: Current.user == game.creator ? game.joiner : game.creator }
    )
  end
  

  def ensure_joined
    unless @game && (@game.creator == current_user || @game.joiner == current_user)
      redirect_to games_path, alert: 'You must join the game to view it.'
    end
  end

end
