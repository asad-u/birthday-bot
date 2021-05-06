Rails.application.routes.draw do
  root 'home#index'
  namespace :slack do
    get 'auth/redirect', to: 'auth#sign_in'
    get 'auth/sign_out', to: 'auth#sign_out'
    get 'install', to: 'auth#install'
    post 'interaction', to: 'callbacks#interaction'
    post 'event_hook', to: 'callbacks#event_hook'

    resources :commands, only: [] do
      collection do
        post :birthday
      end
    end
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
