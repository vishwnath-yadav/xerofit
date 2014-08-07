Xerofit::Application.routes.draw do
# , ActiveAdmin::Devise.config

#   ActiveAdmin.routes(self)
  root 'website#home'
  
  devise_for :users, :controllers => {:registrations => "registrations", :passwords => "passwords"}
  # devise_for :users, :controllers => {:passwords => "passwords"}
  # get '/auth/:provider/callback', to: 'sessions#create'

  devise_scope :user do
   get "/combo_signup" => "registrations#combo_signup"
   get "/users_sign_up_new" => "registrations#users_sign_up_new"
   get "/reset_password" => "passwords#reset"
   post "/users_sign_up_create" => "registrations#users_sign_up_create"
 end 

 match 'auth/:provider/callback', to: 'dashboard#create', via: [:get, :post]
  # match 'signout', to: 'welcome#destroy', as: 'signout', via: [:get, :post]
 match 'auth/failure', to: redirect('/'), via: [:get, :post]

  #get "/combo_signup", :to => "registrations#combo_signup"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # resources :home do
  #   collection do
  #     get 'confirmation'
  #     get 'test'
  #   end
  # end

  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard
    resources :users do
      collection do
        get :filter_user
      end
      member do
        patch :enable
        patch :disable
      end
    end
  end
  
  resources :subscriptions do
    collection do
     get 'trainers_in'
     get 'trainers_confirm' 
    end
  end
  
  resources :users do
    get :dashboard
    get :library
  end
 
  resources :dashboard, path: :home do
    collection do 
      # get 'trainer'
      get '/', to: 'dashboard#trainer', as: :trainer
      get 'confirmation'
    end
  end
  # get 'dashboard', to: 'dashboard#trainer_index', as: :dashboard
  
  resources :videos, only: [:create,:update,:destroy]
  
  get '/library/new', to: 'libraries#new'
  get '/library/move/:id', to: 'libraries#edit', as: :edit
  get '/library/user/:id', to: 'libraries#index'
  resources :libraries, except: [:edit, :show], path: :library do 
    collection do
      get 'sort_video'
      get 'see_more_thumbnail'
      get 'library_search_by_name'
      get 'autocomplete_library_title'
      post 'filter'
    end
    member do
      
    end
  end
  
  get '/builder/new', to: 'workouts#new'
  get '/library/workout/:id', to: 'workouts#workout_details', as: :workout_details
  resources :workouts, except: [:edit, :show], path: :builder do
    collection do
      get 'get_workout_sub_block'
      post 'save_blocks'
      get 'load_lib_details'
      patch 'save_lib_details'
      get 'search_lib'
      get 'autocomplete_library_title'
      get 'remove_library_from_block'
    end
    member do
      # get 'workout_details'
      get '/edit', to: 'workouts#edit', as: :edit
    end
  end
  
  resources :settings do
    collection do
      get 'payment_billing'
      get 'change_password'
      put 'update_password'
      post 'save_payment_billing'
      get 'marketplace'
    end
  end
  get '/subregion_options' => 'settings#subregion_options'

  resources :website do
    collection do
      get 'trainers'
      get 'terms'
      get 'privacy'
    end
  end



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
