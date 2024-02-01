class AddPhoneNumberToPlayer < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :phone_number, :string
  end
end
