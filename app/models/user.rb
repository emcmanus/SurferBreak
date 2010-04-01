class User < ActiveRecord::Base
  
  acts_as_authentic
  
  has_many    :games
  belongs_to  :reward,     :dependent => :destroy
  belongs_to  :user_photo
  
  # TODO: cleanup old methods:
  
  # Update or create expired caches
  # def update_caches
  #   fb_cache = self.facebook_cache || self.build_facebook_cache
  #   fb_cache.refresh_cache unless fb_cache.is_valid?
  #   
  #   # Update FB cache in memcache
  # end
  
  # Build FB cache on connect
  def before_connect(facebook_session)
    # Only setup the first fime -- debug
    # TODO: create user_reward but only on the first connect
    unless self.reward
      reward = self.build_reward
      reward.num_bug_cookies_visible = 1
      reward.num_users_recruited_hidden = 2
      reward.save
    end
    
    # Use existing session to fill out cache
    # fb_cache = self.facebook_cache || self.build_facebook_cache
    # fb_cache.refresh_cache facebook_session.user
  end
  
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
    return self[field] unless self[field].blank?
    return self.fb_get field
  end
  
  def fb_get(field)
    # TODO: is marshalling the Facebooker::User object really the best way to go? What about just saving a simple hash?
    unless Rails.cache.exist? self.facebook_id
      fb_user = Facebooker::User.new self.facebook_id
      begin
        fb_user.populate
      rescue Facebooker::Model::UnboundSessionException
        logger.error "UnboundSessionException, attempting to populate a FB User which isn't bound to an API session."
      end
      Rails.cache.write self.facebook_id, fb_user, :expires_in => 24.hours if fb_user.populated?
    end
    obj = Rails.cache.read self.facebook_id
    return obj.instance_eval "@" + field.to_s
  end
  
end
