Rails.application.routes.draw do
  resources :purposes, only: %i[create destroy index show]

  resources :tags, only: %i[create destroy index show]

  resources :txns, only: %i[create destroy index show update]
  post '/txns/:id/tags', to: 'txns#add_tags', as: 'add_tags'
  delete '/txns/:id/tags', to: 'txns#delete_tags', as: 'delete_tags'

  resources :wallets, only: %i[create destroy index show update]
end
