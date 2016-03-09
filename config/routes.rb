Rails.application.routes.draw do
  resources :users, only: [:new, :create, :show, :index]
  resource :session, only: [:new, :create, :destroy]
  resources :teams, only: [:index, :create, :destroy]
  resources :games, only:[:index, :create, :destroy]
  resources :picks
  resources :rounds, only:[:index]
  resources :statics, only:[:index]

  root to: 'statics#index'
end
