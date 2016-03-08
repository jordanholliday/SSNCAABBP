Rails.application.routes.draw do
  resources :users, only: [:new, :create, :show]
  resource :session, only: [:new, :create, :destroy]
  resources :teams, only: [:index, :create, :destroy]
  resources :games, only:[:index, :create, :destroy]
  resources :picks, only:[:new, :index, :create]

  root to: 'users#new'
end
