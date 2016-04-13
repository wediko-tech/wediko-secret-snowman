require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users

  ActiveAdmin.routes(self)

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'events#index'

  devise_scope :user do
    get 'login' => 'devise/sessions#new'
    post 'logout' => 'devise/sessions#destroy'
    get 'sign_up' => 'devise/registrations#new'
  end

  resources :events, only: [:index, :show] do
    resources :wishlists, controller: 'lists', only: [:new, :create]
  end

  resources :wishlists, controller: 'lists', except: [:new, :create] do
    collection do
      delete 'destroy_multiple'
    end

    member do
      get 'gift_requests/new'
      post 'gift_requests/new' => 'gift_requests#create'
      # [SJP] Go back and fix this when we have time - list ID can be grabbed directly from the gift req
      # We define this route because we need the list id for the "back button" when editing a request
      get 'gift_requests/:gift_request_id/edit' => 'gift_requests#edit', as: :gift_request_edit
    end
  end

  resources :gift_requests do
    collection do
      delete 'destroy_multiple'
    end
  end

  get 'not_implemented' => 'not_implemented#index'

  # http://website.com/async/
  mount Sidekiq::Web => 'async'

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
