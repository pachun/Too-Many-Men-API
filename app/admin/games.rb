ActiveAdmin.register Game do
  permit_params :played_at,
    :is_home_team,
    :rink,
    :opposing_teams_name,
    :goals_for,
    :goals_against
end

class Game < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    [
      "id",
      "id_value",
      "created_at",
      "updated_at",
      "played_at",
      "is_home_team",
      "rink",
      "opposing_teams_name",
      "goals_for",
      "goals_against",
    ]
  end
end
