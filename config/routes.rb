Rails.application.routes.draw do
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
  resources :destinations do
    collection do
      get :new_schedule
    end
  end
  
  #relationship
  resources :relationships, only: [:create, :destroy]
  
  #favorite
  post "favorites/:destination_id/create", to: "favorites#create"
  delete "favorites/:destination_id/destroy", to: "favorites#destroy"
  
  #comment
  resources :comments, only: [:create, :destroy]
  
  #notification
  resources :notifications, only: [:index, :destroy]
  
end
