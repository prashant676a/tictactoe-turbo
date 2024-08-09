class GamesController < ApplicationController
  include ActionView::RecordIdentifier
  
  before_action :authenticate_user!
  before_action :set_game, only: [:show, :update, :move]


  def index
  end

  def new
    @game = Game.new
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
    
  end

  def join
    if params[:game_id].present?
      game_id = params[:game_id].split('/').last
      @game = Game.find_by(id: game_id)
      if @game && @game.joiner.nil? && @game.creator != current_user
        @game.joiner = current_user
        @game.joiner_symbol = @game.creator_symbol == "X" ? "O" : "X"

        if @game.save
          Current.user = current_user
          respond_to do |format|
            format.html { redirect_to @game }
            format.turbo_stream {render turbo_stream: turbo_stream.replace(@game, partial: 'games/game', locals: { game: @game, user: Current.user }) }
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
    # broadcast_game_update(@game)
    @game.update(game_params)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @game }
    end
  end

  def move
    
    row = params[:row].to_i
    col = params[:col].to_i

    if @game.move!(row, col)
      Current.user = current_user
      broadcast_game_update(@game)

      respond_to do |format|
        # format.turbo_stream
        format.html{redirect_to @game}
      end

    else
      redirect_to @game, alert: 'Invalid move.'
    end

    
  end

  private

  def set_game
    @game = Game.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to games_path, alert: 'Game not found.'
  end

  def game_params
    params.require(:game).permit(:creator_id, :joiner_id, :creator_symbol, :joiner_symbol, :state, :current_symbol)
  end
  
  def broadcast_game_update(game)
    Turbo::StreamsChannel.broadcast_replace_to(
      game,
      target: dom_id(game),  # Now you can use dom_id
      partial: 'games/game',
      locals: { game: game, user: Current.user == game.creator ? game.joiner : game.creator }
    )
  end

end
