Rails.application.routes.draw do
  root to: "product_imports#new"
  resource :product_import, only: %i[new create]
  resources :products, only: %i[index]
end
