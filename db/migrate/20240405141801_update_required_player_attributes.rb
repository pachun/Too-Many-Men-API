class UpdateRequiredPlayerAttributes < ActiveRecord::Migration[7.1]
  def change
    change_column :players, :first_name, :string, null: true, default: nil
    change_column :players, :last_name, :string, null: true, default: nil
    change_column :players, :phone_number, :string, null: false
  end
end
