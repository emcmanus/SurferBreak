# create_table "games", :force => true do |t|
#   t.float    "avg_rating",                  :default => 0.0
#   t.integer  "num_ratings",                 :default => 0
#   t.float    "ranked_value",                :default => 0.0
#   t.boolean  "deleted",                     :default => false
#   t.boolean  "received_dmca_takedown",      :default => false
#   t.integer  "play_count",                  :default => 0
#   t.string   "platform",                    :default => "NES", :null => false
#   t.text     "description"
#   t.string   "title"
#   t.boolean  "is_adult",                    :default => false
#   t.string   "storage_object_id",                              :null => false
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.boolean  "user_has_selected_thumbnail"
#   t.boolean  "file_uploaded"
#   t.boolean  "file_published"
#   t.integer  "user_id"
#   t.integer  "thumbnail_id"
#   t.string   "original_filename"
# end

require 'json'

class Game < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :thumbnail   # Default thumbnail
  
  has_many :ratings
  
  
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
  
  
  attr_accessor :is_uploaded
  
  def is_uploaded=(value)
    if (value == true)
      puts "calling enqueue job"
      enqueue_job
    end
    @is_uploaded = value
  end
  
  def is_uploaded
    @is_uploaded
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
    # begin
      attempts += 1
      send_success = queue.send_message job_message.to_json
      raise unless send_success
    # rescue
    #   puts e
    #   retry if attempts < 3
    # end
  end
  
end
