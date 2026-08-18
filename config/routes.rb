Rails.application.routes.draw do
  root "home#index"

  get "signup", to: "users#new"
  post "signup", to: "users#create"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "dashboard", to: "dashboard#show"

  resources :swap_requests, only: %i[new create]

  namespace :manager do
    resources :swap_requests, only: [:index] do
      member do
        patch :approve
        patch :deny
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
