Mymobade::Application.routes.draw do
  root to: "login#login"
  
  match "login" => "login#login"
  match "login/project" => "login#project"
  match "login/project/:project_id" => "login#project"
  match "login/category" => "login#category"
  match "login/category/:category_id" => "login#category"
  match "login/branch" => "login#branch"
  match "login/branch/:branch_id" => "login#branch"
  match "login/branch/:branch_id/:leaf" => "login#branch"
  
  match "agenda" => "agenda#all"
  match "agenda/week" => "agenda#week"
  match "agenda/week/:week_id" => "agenda#week"
  match "agenda/day" => "agenda#day"
  match "agenda/day/:week_id/:day_id" => "agenda#day"

  match "logout" => "logout#logout"
  
  match "options" => "options#options"
  
  match "bookmark/:username/:password/:domain_/:project_id/:category_id/:branches_id" => "bookmark#login"

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
