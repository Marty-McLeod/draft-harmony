Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  get "how-to", to: "pages#how_to"
  
  resources :tasks do
    resources :outlines, only: [:new, :create, :destroy]
    resources :notes, only: [:new, :edit, :update, :create, :destroy]
  end

  # get "tasks", to: "tasks#index"
  # get "tasks/:id", to: "tasks#show"
  # get "tasks/:id/edit", to: "tasks#edit"
  # post "tasks/:id/edit", to: "tasks#update"

end
