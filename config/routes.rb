ActionController::Routing::Routes.draw do |map|
  
  # Sessions
  map.resource :user_session
  
  # My Profile
  map.resource :account, :controller => "users" # /account/new => users#new
  
  # Games
  map.game "games/:id", :controller => "games", :action => "show"
  map.resource :game, :controller => "games"
  
  # User profiles .com/users/14
  map.user "users/:id", :controller => "users", :action => "showPublicProfile"
  
  # List
  map.list "list", :controller => "list", :action => "show"
  
  # Uploader
  map.upload          "upload",               :controller => "upload", :action => "show"
  map.upload_key      "upload/policy",        :controller => "upload", :action => "generate_policy" # S3 Policy Generation
  map.upload_finish   "upload/file_finished", :controller => "upload", :action => "file_finished"   # Single file uploaded
  map.upload_publish  "upload/publish",       :controller => "upload", :action => "publish"         # All files uploaded
  
  # HTML Uploader
  map.html_upload         "upload/html",          :controller => "upload", :action => "html_uploader"
  map.html_upload_finish  "upload/html/upload",   :controller => "upload", :action => "html_uploader_finish"
  
  # Home
  map.root :controller => "home", :action => "show"
  
  
  
  
  
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
  
  
  # Internal Use
  
end



# 
# 
# 
#     SEO-Friendly Routes
#     
# 
# # Your Stuff
# 
# surferbreak.com/account                     // This is all stuff unique to "you" the user, eventually we can add summary type stuff
# surferbreak.com/account/profile             // For now this is the same as /account
# surferbreak.com/account/profile/edit        // Edit your account
# surferbreak.com/account/settings            // Account settings (privacy, email settings)
# surferbreak.com/account/settings/edit       // Edit account settings
# surferbreak.com/account/games               // "My Games" - list and manage the games you've uploaded
# surferbreak.com/account/games/edit/:id      // Edit a game
# surferbreak.com/account/forgot_password     // Password reset and mailer
# 
# 
# # Other People's Stuff
# 
# surferbreak.com/users                       // Like Scribd's "Explore" for users - search, new users, recently active, etc.
# surferbreak.com/users/$login                // User profile
# surferbreak.com/console-games               // Like Scribd's "Explore" for games - search, new games, recently active, etc.
# surferbreak.com/console-games/$slug/$id     // Play the game
# 
# 
# # Community Stuff - Other People in Aggregate
# 
# surferbreak.com/home                        // The state of the community - new games, users, comments, etc.
# 
# 
# # Other
# 
# surferbreak.com/register        // Register -> surferbreak.com/account/new
# surferbreak.com/login           // Login    -> surferbreak.com/user_sessions/new
# surferbreak.com/logout          // Log out -> surferbreak.com/user_sessions/destroy
# 
# 
# # Internal controllers
# 
# surferbreak.com/internal            // Site Summary
# surferbreak.com/internal/admin      // Take action, DMCA, bans, group messages, etc.
# 










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