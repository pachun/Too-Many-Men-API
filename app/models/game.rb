class Game < ApplicationRecord
  belongs_to :team

  has_many :player_attendances
  has_many :players, through: :team

  enum rink: {
    "Rink A": 0,
    "Rink B": 1,
    "Rink C": 2,
    "Rink D": 3,
  }
end
