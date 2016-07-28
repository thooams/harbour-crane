Rails.application.routes.draw do

  get 'settings/index'
  get 'home/index'
  get 'proxy/index' => 'proxy#index', as: :proxy
  get 'about/index' => 'about#index', as: :about
  get 'store/index' => 'store#index', as: :store

  resources :apps do
    member do
      # Main actions
      get :restart
      get :start
      get :stop

      # Database actions
      get :db_drop
      get :db_create
      get :db_migrate
      get :db_seed
    end
    collection do
      get :relaunch
      get :start_all
      get :stop_all
    end
  end

  resources :images

  resources :containers do
    member do
      get :restart
      get :stop
      get :start
    end
  end

  root 'home#index'

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
