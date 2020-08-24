Rails.application.routes.draw do
  root to: 'toppages#home'
  
  #user
  get 'signup', to: "users#new"
  resources :users, only: [:index, :show, :new, :create]
  
  
end
