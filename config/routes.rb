Rails.application.routes.draw do
  resources :players, only: [:index]
  resources :games, only: [:index]

  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
