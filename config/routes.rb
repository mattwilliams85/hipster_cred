Rails.application.routes.draw do
  root :to => "users#index"

  resources :datasets
  resources :users
end
