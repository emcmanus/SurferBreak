ActionController::Routing::Routes.draw do |map|
  
  # Sessions
  map.resource              :user_session
  
  # Your Stuff
  # TODO: move to "account" namespace
  map.account               "account",                  :controller => "users",   :action => "show"    # This is all stuff unique to "you" the user, eventually we can add account summary type stuff
  map.profile               "account/profile",          :controller => "users",   :action => "show"    # For now this is the same as /account
  map.edit_profile          "account/profile/edit",     :controller => "users",   :action => "edit"    # Edit your account
  map.friends               "account/friends",          :controller => "friends", :action => "show"
  map.account_settings      "account/settings",         :controller => "users",   :action => "edit"    # Account settings (privacy, email settings)
  map.edit_account_settings "account/settings/edit",    :controller => "users",   :action => "edit"    # Edit account settings
  map.account_games         "account/games",            :controller => "users",   :action => "show"    # "My Games" - list and manage the games you've uploaded
  map.edit_game             "account/games/edit/:id",   :controller => "games",   :action => "edit"    # Edit a game
  map.forgot_password       "account/forgot_password",  :controller => "users",   :action => "edit"    # Password reset and mailer
  
  # Other People's Stuff
  map.user                  "users/:id",                :controller => "users", :action => "show"     # User profile
  map.game                  "console-games/:id",        :controller => "games", :action => "show"     # Play the game
  
  # Surferbreak Games
  map.memory_game           "games/memory",             :controller => "games/memory", :action => "show"
  
  # Community Stuff - Other People in Aggregate -- TODO: Remove TEMPORARY path "list"
  map.list                  "list",                     :controller => "list",  :action => "show"
  map.list_users            "users",                    :controller => "list",  :action => "show"           # User summary - search, new users, recently active, etc.
  map.list_games            "console-games",            :controller => "list",  :action => "show"           # Game summary - search, new games, recently active, etc.
  map.home                  "home",                     :controller => "home",  :action => "show"           # The state of the community - new games, users, comments, etc.
  map.root                                              :controller => "home",  :action => "show"
      
  # Other
  map.register              "register",                 :controller => "users",           :action => "new"      # Register -> surferbreak.com/account/new
  map.register_submit       "register/submit",          :controller => "users",           :action => "create"
  map.login                 "login",                    :controller => "user_sessions",   :action => "new"      # Login    -> surferbreak.com/user_sessions/new
  map.logout                "logout",                   :controller => "user_sessions",   :action => "destroy"  # Sign out -> surferbreak.com/user_sessions/destroy
  
  
  # Uploaders
  map.upload                "upload",                   :controller => "upload", :action => "show"            # Show uploader
  map.upload_key            "upload/policy",            :controller => "upload", :action => "generate_policy" # S3 policy generation
  map.upload_finish         "upload/file_sent",         :controller => "upload", :action => "file_sent"       # Single file uploaded
  
  map.namespace(:upload) do | upload |
    upload.resource         :publish,                   :controller => :publish, :only => [:index, :show, :create]
    upload.html             'html',                     :controller => "html", :action => "show"
  end
  
  # Internal Admin Panels
  map.connect               "internal",                 :controller => "list",  :action => "show"       # Aggregate Site Summary
  map.connect               "internal/admin",           :controller => "list",  :action => "show"       # Take action, DMCA, bans, group messages, etc.

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