Rails.application.routes.draw do
  resources :purposes, only: %i[create destroy index show]
  resources :tags, only: %i[create destroy index show]
  # resources :transactions, only: %i[create index]
end
