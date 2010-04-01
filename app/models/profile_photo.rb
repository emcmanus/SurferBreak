# create_table "profilePhotos", :force => true do |t|
#   t.integer "user_id"
#   t.string  "storage_object_id", :null => false
#   t.string  "original_filename", :null => false
#   t.integer "width",             :null => false
#   t.integer "height",            :null => false
# end


class ProfilePhoto < ActiveRecord::Base
  belongs_to :user
  
  def self.s3_bucket_path
    "http://#{S3Keys::S3Config.bucket}.s3.amazonaws.com/"
  end
  
  
  def self.s3_directory
    "profile_photos"
  end
  
  
  def self.s3_path
     self.s3_bucket_path + self.s3_directory
  end
  
  
  def s3_path
    self.class.s3_path + "/" + self[:storage_object_id]
  end
end