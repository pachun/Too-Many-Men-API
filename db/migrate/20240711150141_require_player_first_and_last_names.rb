class RequirePlayerFirstAndLastNames < ActiveRecord::Migration[7.1]
  def change
    change_column_null :players, :first_name, false, ""
    change_column_null :players, :last_name, false, ""
  end
end
