class Thumbnail < ActiveRecord::Base
  belongs_to :game    # Many thumbnails to one game
  
  
  def self.s3_bucket_path
    "http://#{S3Keys::S3Config.bucket}.s3.amazonaws.com/"
  end
  
  
  def self.s3_directory
    "screenshots"
  end
  
  
  def self.s3_path
     self.s3_bucket_path + self.s3_directory
  end
  
  
  def s3_path
    self.class.s3_path + "/" + self[:storage_object_id]
  end
end
