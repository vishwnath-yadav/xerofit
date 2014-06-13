Xerofit::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  # devise_for :users, :controllers => {:sessions => "sessions"}
  # get '/auth/:provider/callback', to: 'sessions#create'

  devise_scope :user do
   get "/combo_signup" => "registrations#combo_signup"
   get "/users_sign_up_new" => "registrations#users_sign_up_new"
   post "/users_sign_up_create" => "registrations#users_sign_up_create"
 end 

 match 'auth/:provider/callback', to: 'home#create', via: [:get, :post]
  # match 'signout', to: 'welcome#destroy', as: 'signout', via: [:get, :post]
 match 'auth/failure', to: redirect('/'), via: [:get, :post]

  #get "/combo_signup", :to => "registrations#combo_signup"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  resources :home do
    member do
    end

    collection do
    end
  end

  root 'home#index'
  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard
    resources :users do
      member do
        put :enable
        put :disable
      end
    end
    
  end
  resources :subscriptions
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
