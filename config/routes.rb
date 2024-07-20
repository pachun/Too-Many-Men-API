Rails.application.routes.draw do
  resources :teams, only: [:index] do
    resources :players, only: [:index, :show]
    resources :games, only: [:index, :show] do
      resources :player_attendance, only: [:create]
    end
  end

  post "/text_message_confirmation_codes/deliver",
    to: "text_message_confirmation_codes#deliver"
  post "/text_message_confirmation_codes/check",
    to: "text_message_confirmation_codes#check"

  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
