class UpdatePlayerNameToFirstNameAndLastName < ActiveRecord::Migration[7.1]
  def change
    remove_column :players, :name
    add_column :players, :first_name, :string, null: false
    add_column :players, :last_name, :string, null: false
  end
end
