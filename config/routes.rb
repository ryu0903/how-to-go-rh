Rails.application.routes.draw do
  get 'sessions/new'
  root to: 'toppages#home'
  
  #user
  get 'signup', to: "users#new"
  resources :users, only: [:index, :show, :new, :create]
  
  #session
  get 'login', to: "sessions#new"
  post 'login', to: "sessions#create"
  delete 'logout', to: "sessions#destroy"
  
  
end
