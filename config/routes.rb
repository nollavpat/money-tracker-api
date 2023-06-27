Rails.application.routes.draw do
  resources :purposes, only: %i[create destroy index show]

  resources :tags, only: %i[create destroy index show]

  resources :txns, only: %i[create destroy index show update]

  resources :wallets, only: %i[create destroy index show update]
  post '/wallets/:id/debit', to: 'wallets#debit', as: 'debit'
  post '/wallets/:id/credit', to: 'wallets#credit', as: 'credit'
end
