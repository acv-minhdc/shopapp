Rails.application.routes.draw do
  devise_for :admins, controllers: { sessions: 'admins/sessions' }
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'products#index'

  resources :products, only: [:index, :show]
  resources :categories, only: [:index, :show]
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'index' => 'pages#index'

  # Custom cart/session cart
  get 'cart' => 'cart#index', :as => 'cart_index'
  post 'cart' => 'cart#change_quantity'
  post 'cart/add/:id' => 'cart#add', :as => 'cart_add'
  delete 'cart/remove/:id' => 'cart#delete', :as => 'cart_delete'
  delete 'cart/empty' => 'cart#empty', :as => 'empty_cart'

  resources :orders, only: [:index, :new] do
    collection do
      post 'checkout'
      get 'execute_payment'
    end
  end

  get 'orders/:paymentId' => 'orders#show', as: 'show_order'
end
