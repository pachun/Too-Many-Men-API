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
    column :played_at
    column :is_home_team
    column :rink
    column :goals_for
    column :goals_against
  end
end

class Game < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    @ransackable_attributes ||= column_names + _ransackers.keys + _ransack_aliases.keys + attribute_aliases.keys
  end

  def self.ransackable_associations(auth_object = nil)
    reflect_on_all_associations.map { |a| a.name.to_s } + _ransackers.keys
  end

  def display_name
    "#{played_at.strftime("%F")} #{opposing_teams_name ? "v #{opposing_teams_name}" : "" }"
  end
end
