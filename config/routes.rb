Rails.application.routes.draw do

  namespace :site do
    get 'welcome/index'
  end

  namespace :users_backoffice do
    get 'welcome/index'
  end

  namespace :admins_backoffice do
    resources :admins, except: [:delete] # Administrados
    get 'welcome/index' # Dashboard

  end

  devise_for :admins
  devise_for :users

  root to: 'site/welcome#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
