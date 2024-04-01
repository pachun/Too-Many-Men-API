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
    @ransackable_attributes ||= column_names + _ransackers.keys + _ransack_aliases.keys + attribute_aliases.keys
  end

  def display_name
    "#{played_at.strftime("%F")} #{opposing_teams_name ? "v #{opposing_teams_name}" : "" }"
  end
end
