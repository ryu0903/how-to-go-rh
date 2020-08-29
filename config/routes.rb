Rails.application.routes.draw do
  get 'sessions/new'
  root to: 'toppages#home'
  
  #user
  get 'signup', to: "users#new"
  resources :users
  
  #session
  get 'login', to: "sessions#new"
  post 'login', to: "sessions#create"
  delete 'logout', to: "sessions#destroy"
  
  #destination
  resources :destinations
  
end
