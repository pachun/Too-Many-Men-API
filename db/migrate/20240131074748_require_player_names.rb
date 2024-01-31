class RequirePlayerNames < ActiveRecord::Migration[7.1]
  def change
    change_column_null :players, :name, false
  end
end
