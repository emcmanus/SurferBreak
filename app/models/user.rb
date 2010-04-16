# create_table "users", :force => true do |t|
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.string   "username"
#   t.string   "email"
#   t.string   "crypted_password"
#   t.string   "password_salt"
#   t.string   "persistence_token"
#   t.string   "single_access_token"
#   t.string   "perishable_token"
#   t.integer  "login_count",          :default => 0,     :null => false
#   t.integer  "failed_login_count",   :default => 0,     :null => false
#   t.datetime "last_request_at"
#   t.datetime "current_login_at"
#   t.datetime "last_login_at"
#   t.string   "current_login_ip"
#   t.string   "last_login_ip"
#   t.text     "about"
#   t.string   "name"
#   t.string   "facebook_id"
#   t.string   "facebook_session_key"
#   t.boolean  "facebook_new_user",    :default => false, :null => false
#   t.boolean  "use_our_photo",        :default => false, :null => false
#   t.integer  "profilePhoto_id"
#   t.integer  "reward_id"
# end


class User < ActiveRecord::Base
  
  acts_as_authentic
  
  has_many    :games
  belongs_to  :reward,     :dependent => :destroy
  belongs_to  :user_photo
  
  def before_validation
    # Other Set up
    unless self.reward
      reward = self.build_reward
      reward.num_bug_cookies_visible = 1
      reward.save
    end
  end
  
  
  # Build FB cache on connect
  
  # def before_connect(facebook_session)
  #   unless self.reward
  #     reward = self.build_reward
  #     reward.save
  #   end
  # end
  
  # def facebook_user
  #   return Facebooker::User.new self.facebook_id
  # end
  
    
  # 
  # Always use the following safe methods for users (which fall thru to the FB cache):
  # 
  
  # def fb_get(field)
  #   # TODO: is marshalling the Facebooker::User object really the best way to go? What about saving a hash?
  #   unless Rails.cache.exist? self.facebook_id
  #     logger.warn "[DEBUG] cache does NOT exist"
  #     fb_user = facebook_user
  #     begin
  #       fb_user.populate
  #     rescue Facebooker::Model::UnboundSessionException
  #       logger.error "UnboundSessionException, attempting to populate a FB User which isn't bound to an API session."
  #     end
  #     Rails.cache.write self.facebook_id, fb_user, :expires_in => 24.hours if fb_user.populated?
  #   else
  #     logger.warn "[DEBUG] cache exists"
  #   end
  #   obj = Rails.cache.read self.facebook_id
  #   return obj.instance_eval field.to_s
  # end
  
  # Name || username
  def display_name(default=nil)
    return self.safe_get(:name) unless self.safe_get(:name).blank?
    return self.safe_get(:username) unless self.safe_get(:username).blank?
  end
  
  # Fall thru to FB cache if the user-defined field is empty or nil
  def safe_get(field)
    return self[field] unless self[field].blank?
    # return self.fb_get field
  end
  

end
