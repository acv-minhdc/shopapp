Rails.application.routes.draw do
  root 'products#index'

  resources :products, :categories

  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'index' => 'pages#index'

  # Custom cart/session cart
  get 'cart' => 'cart#index', :as => 'cart_index'
  post 'cart' => 'cart#change_quantity'
  post 'cart/add/:id' => 'cart#add', :as => 'cart_add'
  delete 'cart/remove/:id' => 'cart#delete', :as => 'cart_delete'
  delete 'cart/empty' => 'cart#empty', :as => 'empty_cart'

  resources :orders, only: [:new, :show] do
    collection do
      post 'checkout'
      get 'execute_payment'
    end
  end
end
