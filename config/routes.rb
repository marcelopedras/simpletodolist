Simpletodolist::Application.routes.draw do

  get "list_manager/index"

  devise_for :users

  root :to => 'list_manager#index', :as =>:index


  post 'complete_list' => 'list_manager#complete_list'
  post 'new_list' => 'list_manager#new_list', :as => :new_list
  post 'new_task' => 'list_manager#new_task', :as => :new_task
  get  'show_list' => 'list_manager#show_list', :as => :show_list
  post 'complete_task' => 'list_manager#complete_task', :as => :complete_task
  post 'complete_list' => 'list_manager#complete_list', :as => :complete_list
  post 'delete_task' => 'list_manager#delete_task', :as => :delete_task
  post 'delete_list' => 'list_manager#delete_list', :as => :delete_list
  get  'show_favorite' => 'list_manager#show_favorite', :as => :show_favorite
  post  'find_favorite' => 'list_manager#find_favorite', :as => :find_favorite
  post 'add_favorite' => 'list_manager#add_favorite', :as => :add_favorite
  post 'delete_favorite' => 'list_manager#delete_favorite', :as => :delete_favorite
  get 'show_public_list' => 'list_manager#show_public_list', :as => :show_public_list
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
