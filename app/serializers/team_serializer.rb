class TeamSerializer
  def self.serialize(team)
    new(team).serialize
  end

  attr_reader :team

  def initialize(team)
    @team = team
  end

  def serialize
    {
      "id" => team.id,
      "name" => team.name,
    }
  end
end
