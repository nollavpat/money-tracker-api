Rails.application.routes.draw do
  resources :transactions, only: [:create, :index]
end
