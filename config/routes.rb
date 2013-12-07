DriftingLibraryRor::Application.routes.draw do

  root 'welcome#index'

  get "users/new"
  match '/signup',to:'users#new',via:'get'
  match '/users/:id/request_list', to:'users#request_list', via:'get'
  match '/users/:id/request_list/send_book', to:'users#send_book', via: 'post'
  match '/users/:id/pending_list', to:'users#pending_list', via:'get'
  match '/users/:id/request_list/confirm_book', to:'users#confirm_book', via: 'post'
  resources :users

  match '/books/search', to: 'books#search', via: 'get', as: 'search'
  match '/donate',to:'books#donate',via:'post'
  match '/books/:id/wish', to: 'books#wish', via: 'post' 
  match '/books/:id/cancel_wish', to: 'books#cancel_wish', via: 'post'
  match '/books/:id/donate_again', to: 'books#donate_again', via: 'post'
  resources :books

  match '/signin',to:'sessions#new',via:'get'
  match '/signout',to:'sessions#destroy',via:'delete'
  resources :sessions, only: [:new, :create, :destroy]

  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
