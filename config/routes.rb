Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root "dashboard#show"

  resources :categories
  resources :transactions
end
