Rails.application.routes.draw do
  resources :games, only: [:index] do
    resources :player_attendance, only: [:create]
  end
  resources :players, only: [:index, :show]
  get '/players/:id/send_text_message_confirmation_code',
    to: "players#send_text_message_confirmation_code"
  post '/players/:id/check_text_message_confirmation_code',
    to: "players#check_text_message_confirmation_code"

  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
