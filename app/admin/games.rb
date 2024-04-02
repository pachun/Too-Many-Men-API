ActiveAdmin.register Game do
  permit_params :team,
    :played_at,
    :is_home_team,
    :rink,
    :opposing_teams_name,
    :goals_for,
    :goals_against

  index do
    id_column
    column :team
    column :is_home_team
    column :opposing_teams_name
    column :played_at
    column :rink
    column :goals_for
    column :goals_against
  end
end

class Game < ApplicationRecord
  def display_name
    "#{team.display_name} v #{opposing_teams_name}"
  end
end
