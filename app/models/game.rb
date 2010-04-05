
# create_table "games", :force => true do |t|
#   t.float    "avg_rating",                  :default => 0.0,   :null => false
#   t.integer  "num_ratings",                 :default => 0,     :null => false
#   t.float    "ranked_value",                :default => 0.0,   :null => false
#   t.boolean  "deleted",                     :default => false, :null => false
#   t.boolean  "received_dmca_takedown",      :default => false, :null => false
#   t.integer  "play_count",                  :default => 0,     :null => false
#   t.string   "platform",                    :default => "NES", :null => false
#   t.text     "description"
#   t.string   "title"
#   t.string   "storage_object_id",                              :null => false
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.boolean  "user_has_selected_thumbnail", :default => false, :null => false

# Sent to S3
#   t.boolean  "file_uploaded",               :default => false, :null => false

# Thumbnails Generated (or we know generation failed)
#   t.boolean  "file_processed",              :default => false, :null => false

# User has reviewed game info and published game
#   t.boolean  "file_published",              :default => false, :null => false

#   t.integer  "user_id"
#   t.integer  "thumbnail_id"
#   t.string   "original_filename"
# end

require 'json'

class Game < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :thumbnail   # Default thumbnail
  
  has_many :thumbnails
  has_many :ratings
  
  
  # 
  # Slugs
  
  def self.find_by_url(id)
    id = id.split("-").first.to_i
    return self.find(id)
  end
  
  def slug
    (self.title.to_url.split("-") - StopWords::English.all).first(6).join("-")
  end
  
  # SEO-friendly URL
  def to_param
    "#{self.id}-#{self.platform.downcase}-#{self.slug}"
  end
  
  
  # 
  # Aliases
  
  def self.find_unpublished_for(user)
    return self.all :conditions => { :user_id => user.id, :file_uploaded => true, :file_processed => true, :file_published => false}
    # return self.all :conditions => ["user_id = ? AND file_uploaded = true AND file_processed = true AND file_published = false", user.id]
  end
  
  def self.find_unprocessed_for(user)
    return self.all :conditions => { :user_id => user.id, :file_uploaded => true, :file_processed => false, :file_published => false}
    # return self.all :conditions => ["user_id = ? AND file_uploaded = true AND file_processed = false AND file_published = false", user.id]
  end
  
  
  # 
  # Paths
  
  def self.s3_bucket_path
    "http://#{S3Keys::S3Config.bucket}.s3.amazonaws.com/"
  end
  
  
  def self.s3_directory
    "uploads"
  end
  
  
  def self.s3_path
     self.s3_bucket_path + self.s3_directory
  end
  
  
  def s3_path
    self.class.s3_path + self[:storage_object_id]
  end
  
  
  # 
  # Thumbnail Generation
  
  attr_accessor :is_uploaded
  
  def is_uploaded=(value)
    if (value == true)
      logger.info "calling enqueue job"
      enqueue_job
    end
    self[:file_uploaded] = value
  end
  
  def is_uploaded
    self[:file_uploaded]
  end
  
  private
  
  def enqueue_job
    sqs = RightAws::SqsGen2.new S3Keys::S3Config.access_key_id, S3Keys::S3Config.secret_access_key
    
    job_message = {
        "meta" => {
            "api_version"   => 1,
            "job_type"      => "thumbnail_generation",
            "passthru"      => {
                                "game_id" => self[:id].to_s
                            }
        },
        "source" => {
            "bucket"        => S3Keys::S3Config.bucket.to_s,
            "directory"     => self.class.s3_directory.to_s,
            "storage_id"    => self[:storage_object_id].to_s
        },
        "destination" => {
            "bucket" => S3Keys::S3Config.bucket.to_s,
            "directory" => Thumbnail.s3_directory.to_s,
            "storage_id_prefix" => self[:storage_object_id].to_s + "-"
        }
    }
    
    queue = sqs.queue "UploadProcessingTodo"
    
    attempts = 0
    begin
      attempts += 1
      send_success = queue.send_message job_message.to_json
      raise unless send_success
    rescue
      if attempts < 3
        retry
      else
        raise
      end
    end
  end
  
end
