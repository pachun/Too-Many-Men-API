ActiveAdmin.register Player do
  permit_params :name, :jersey_number
end

class Player < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    [
      "created_at",
      "id",
      "id_value",
      "name",
      "updated_at",
      "jersey_number",
    ]
  end
end
