Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :players, only: [:index]
  get "up" => "rails/health#show", as: :rails_health_check
end
