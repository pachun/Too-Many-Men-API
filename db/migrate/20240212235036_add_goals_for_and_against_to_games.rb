class AddGoalsForAndAgainstToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :goals_for, :integer
    add_column :games, :goals_against, :integer
  end
end
