class Game < ApplicationRecord
  enum rink: {
    "Rink A": 0,
    "Rink B": 1,
    "Rink C": 2,
    "Rink D": 3,
  }
end
