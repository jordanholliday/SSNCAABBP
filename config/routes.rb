Rails.application.routes.draw do
  resources :users, only: [:new, :create, :show]
  resource :session, only: [:new, :create, :destroy]
  resources :teams, only: [:index, :new, :create, :destroy]
  resources :games, only:[:index, :create, :destroy]

  root to: 'users#new'
end
