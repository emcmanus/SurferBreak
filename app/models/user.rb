class User < ActiveRecord::Base
  
  acts_as_authentic
  
  has_many    :games
  belongs_to  :facebook_cache,  :dependent => :destroy
  belongs_to  :user_reward,     :dependent => :destroy
  belongs_to  :user_photo
  
  # 
  # Always use the following safe methods for users (which fall thru to the FB cache):
  # 
  
  # Name || username
  def display_name(default=nil)
    return self.safe_get(:name) unless self.safe_get(:name).blank?
    return self.safe_get(:username) unless self.safe_get(:username).blank?
  end
  
  # Fall thru to FB cache if the user-defined field is empty or nil
  def safe_get(field)
    update_caches
    self.facebook_cache.try(:refresh_cache) unless self.facebook_cache.try :is_valid?
    return self[field] unless self[field].blank?
    return self.facebook_cache[field] if (self.facebook_cache.try :is_valid?, field)
  end
  
  # Update or create expired caches
  def update_caches
    fb_cache = self.facebook_cache || self.build_facebook_cache
    fb_cache.refresh_cache unless fb_cache.is_valid?
  end
  
  # Build FB cache on connect
  def before_connect(facebook_session)
    # Default reward
    unless self.user_reward
      reward = self.build_user_reward
      reward.num_bug_cookies_visible = 1
      reward.num_users_recruited_hidden = 2
      reward.save
    end
    
    # Use existing session to fill out cache
    fb_cache = self.facebook_cache || self.build_facebook_cache
    fb_cache.refresh_cache facebook_session.user
  end
  
end
