class TeamsController < ApiController
  before_action :authenticate_player

  def index
    render json: serialized_teams
  end

  private

  def serialized_teams
    @serialized_teams ||= current_player.teams.map do |team|
      TeamSerializer.serialize(team)
    end
  end
end
