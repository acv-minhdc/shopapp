Rails.application.routes.draw do
  root 'products#index'

  resources :products, :categories

  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'index' => 'pages#index'

  get 'cart' => 'cart#index', :as => 'cart_index'
  post 'cart/add/:id' => 'cart#add', :as => 'cart_add'
  delete 'cart/remove(/:id(/:all))' => 'cart#delete', :as => 'cart_delete'

end
