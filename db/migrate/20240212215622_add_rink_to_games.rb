class AddRinkToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :rink, :integer
  end
end
