class TeamsController < ApiController
  before_action :authenticate_player

  def index
    render json: serialized_teams
  end

  def show
    render json: serialized_team
  end

  private

  def serialized_teams
    @serialized_teams ||= current_player.teams.map do |team|
      TeamSerializer.serialize(team)
    end
  end

  def serialized_team
    @serialized_team ||= TeamSerializer.serialize(Team.find(strong_params[:id]))
  end

  def strong_params
    params.permit(:id)
  end
end
