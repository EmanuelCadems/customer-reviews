Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Raddocs::App => "/docs"

  namespace :v1 do
    resources :reviews
    resources :stores_score, only: [:show]
    resources :services, only: [:create]
  end
end
