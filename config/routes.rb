Rails.application.routes.draw do
  resources :purposes, only: %i[create destroy index show]

  resources :tags, only: %i[create destroy index show]

  resources :txns, only: %i[create destroy index show update] do
    post :payments, on: :collection, action: 'create_payment'
    delete :tags, on: :member, action: 'delete_tags'
    post :tags, on: :member, action: 'add_tags'
  end

  resources :wallets, only: %i[create destroy index show update]
end
