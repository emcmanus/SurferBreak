class FacebookCache < ActiveRecord::Base
  
  has_one :user
  
  def before_validation
    self[:invalidates_at] = 24.hours.from_now
  end
  
  # Cache knows how to update itself
  def refresh_cache(fb_user=nil)
    fb_user ||= Facebooker::User.new self.user.facebook_id
    
    self[:name] = fb_user.name
    self[:email] = fb_user.email
    self[:username] = fb_user.username
    self[:about_me] = fb_user.about_me
    self[:profile_url] = fb_user.profile_url
    self[:sex] = fb_user.sex
    self[:website] = fb_user.website
    
    self[:status_message] = fb_user.status.message
    self[:status_time] = fb_user.status.time
    
    self[:pic] = fb_user.pic
    self[:pic_with_logo] = fb_user.pic_with_logo
    self[:pic_big] = fb_user.pic_big
    self[:pic_big_with_logo] = fb_user.pic_big_with_logo
    self[:pic_small] = fb_user.pic_small
    self[:pic_small_with_logo] = fb_user.pic_small_with_logo
    self[:pic_square] = fb_user.pic_square
    self[:pic_square_with_logo] = fb_user.pic_square_with_logo
    
    self.save
  end
  
  
  def is_valid?(field=nil)
    return true if field and self.storable? field
    return true if (self[:invalidates_at] > Time.now) and self[:invalidates_at]
  end
  
  
  def storable?(field)
    storable_fields = ["uid", "aid", "eid", "email", "flid", "gid", "listing_id", 
      "nid", "notes_count", "page_id", "pid", "post_id", "proxied_email", "profile_update_time"]
    return storable_fields.include? field.to_s.downcase
  end
  
end
