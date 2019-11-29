Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "welcomes#index"
  resources :products do
    collection do
      post :create_product
      post :import
    end
  end
end
