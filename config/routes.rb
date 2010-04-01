ActionController::Routing::Routes.draw do |map|
  
  # Sessions
  map.resource  :user_session
  
  # Profile
  map.resource  :account,     :controller => "users" # /account/new => users#new
  
  # Games
  map.game      "games/:id",  :controller => "games", :action => "show"
  map.resource  :game,        :controller => "games"
  
  # User profiles
  map.user      "users/:id",  :controller => "users", :action => "show"
  
  # List
  map.list      "list",       :controller => "list",  :action => "show"
  
  # Uploader
  map.upload          "upload",               :controller => "upload", :action => "show"            # Show uploader
  map.upload_key      "upload/policy",        :controller => "upload", :action => "generate_policy" # S3 policy generation
  map.upload_finish   "upload/file_sent",     :controller => "upload", :action => "file_sent"       # Single file uploaded
  map.upload_publish  "upload/publish",       :controller => "upload", :action => "publish"         # All uploads completed
  
  # HTML Uploader
  map.html_upload         "upload/html",          :controller => "upload", :action => "html_uploader"
  map.html_upload_finish  "upload/html/upload",   :controller => "upload", :action => "html_uploader_finish"
  
  # Home
  map.root      :controller => "home",  :action => "show"
  
  # Your Stuff
  # map.account             "account",                  :controller => ""
  # map.profile             "account/profile",          :controller => ""
  # map.edit_profile        "account/profile/edit",     :controller => ""
  # map.user_settings       "account/settings",         :controller => ""
  # map.edit_user_settings  "account/settings/edit",    :controller => ""
  # map.my_games            "account/games",            :controller => ""
  # map.edit_game           "account/games/edit",       :controller => ""
  # map.forgot_password     "account/forgot_password",  :controller => ""
  
  # Other People's Stuff
  
  # Community Stuff (Other people in aggregate)
  
  # Other
  map.register  "register",     :controller => "users",           :action => "new"
  
  map.login     "login",        :controller => "user_sessions",   :action => "new"
  map.logout    "logout",       :controller => "user_sessions",   :action => "destroy"
  
  
end











# Routes notes:

# The priority is based upon order of creation: first created -> highest priority.

# Sample of regular route:
#   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
# Keep in mind you can assign values other than :controller and :action

# Sample of named route:
#   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
# This route can be invoked with purchase_url(:id => product.id)

# Sample resource route (maps HTTP verbs to controller actions automatically):
#   map.resources :products

# Sample resource route with options:
#   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

# Sample resource route with sub-resources:
#   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

# Sample resource route with more complex sub-resources
#   map.resources :products do |products|
#     products.resources :comments
#     products.resources :sales, :collection => { :recent => :get }
#   end

# Sample resource route within a namespace:
#   map.namespace :admin do |admin|
#     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
#     admin.resources :products
#   end

# You can have the root of your site routed with map.root -- just remember to delete public/index.html.
# map.root :controller => "welcome"

# See how all your routes lay out with "rake routes"

# Install the default routes as the lowest priority.
# Note: These default routes make all actions in every controller accessible via GET requests. You should
# consider removing or commenting them out if you're using named routes and resources.