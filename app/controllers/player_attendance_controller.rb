class PlayerAttendanceController < ApiController
  before_action :authenticate_player

  def create
    CreateOrUpdatePlayerAttendance.create_or_update(
      game_id: strong_params[:game_id].to_i,
      player_id: current_player.id,
      attending: strong_params[:attending],
    )
    head :created
  end

  private

  def strong_params
    params.permit(:game_id, :attending)
  end
end
