class AddIsHomeTeamToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :is_home_team, :boolean, null: false, default: false
  end
end
