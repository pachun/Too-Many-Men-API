class PlayerAttendanceController < ApiController
  before_action :authenticate_player

  def create
    PlayerAttendance.create(
      player: current_player,
      game: Game.find(strong_params[:game_id]),
      attending: strong_params[:attending],
    )
    head :created
  end

  private

  def strong_params
    params.permit(:game_id, :attending)
  end
end
