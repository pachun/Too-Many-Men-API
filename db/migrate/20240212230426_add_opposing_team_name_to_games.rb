class AddOpposingTeamNameToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :opposing_teams_name, :string
  end
end
