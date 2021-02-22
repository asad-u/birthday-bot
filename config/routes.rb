Rails.application.routes.draw do
  root 'home#index'
  namespace :slack do
    get 'auth/redirect', to: 'auth#sign_in'
    get 'auth/sign_out', to: 'auth#sign_out'
    get 'install', to: 'auth#install'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
