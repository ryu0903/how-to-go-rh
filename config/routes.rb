Rails.application.routes.draw do
  get 'comments/create'
  get 'comments/destroy'
  get 'sessions/new'
  root to: 'toppages#home'
  
  #user
  get 'signup', to: "users#new"
  resources :users do
    member do
      get :followings, :followers, :favorites
    end
  end
  
  #session
  get 'login', to: "sessions#new"
  post 'login', to: "sessions#create"
  delete 'logout', to: "sessions#destroy"
  
  #destination
  resources :destinations
  
  #relationship
  resources :relationships, only: [:create, :destroy]
  
  #favorite
  post "favorites/:destination_id/create", to: "favorites#create"
  delete "favorites/:destination_id/destroy", to: "favorites#destroy"
  
  #comment
  resources :comments, only: [:create, :destroy]
  
end
