class AddJerseyNumberToPlayer < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :jersey_number, :integer
  end
end
