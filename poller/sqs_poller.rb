#!/usr/bin/ruby

# This is a simple SQS poller
# 
# When a new job is received, we'll remove it from the TODO queue, generate the thumbnails,
# POST the thumbnails to S3, and place a job finished message on the DONE queue.
# 
# The poller will loop every 2 seconds, but will immediately check for new jobs upon completion
# of the first. The cost for queries will be about $1.30/server/mo.


require 'rubygems'

require 'active_record'
require 'yaml'
require 'json'
require 'right_aws'


# Constants

MAX_API_VERSION   = 1
JOB_TYPE          = "thumbnail_generation"

# TODO
puts "\n\n\n"
puts "NOTE: BE SURE TO HANDLE THE ENVIRONMENT!!! RIGHT NOW IT'S HARD-CODED TO DEVELOPMENT."
puts "\n\n\n"

require "../config/environment"

# dbconfig = YAML::load(File.open('../config/database.yml'))["development"]
# ActiveRecord::Base.establish_connection(dbconfig)
# 
# # Load all models
# rails_models = Dir["../app/models/*.rb"]
# 
# rails_models.each do |model|
#   require model
# end

class Processor
  def initialize( access_key_id, secret_access_key )
    sqs = RightAws::SqsGen2.new access_key_id, secret_access_key
    @todo_queue = sqs.queue "UploadProcessingTodo"
    @done_queue = sqs.queue "UploadProcessingDone"
    
    @access_key_id = access_key_id
    @secret_access_key = secret_access_key
    
    @root_path  = File.expand_path(File.dirname(__FILE__))
  end
  
  def start
    while true
      @job = @done_queue.pop
      if not @job.nil?
        process
      else
        sleep 2
      end
    end
  end
  
  def rescue
    # See if we can pick out the Game ID; should log eventually
  end
  
  private
    
    def process
      
      begin
        job = JSON.parse @job.body
      rescue JSON::ParserError
        raise
      end
      
      puts "Received finished job: #{@job.body}"
      
      raise if job["meta"]["api_version"] > MAX_API_VERSION
      raise if job["meta"]["job_type"] != JOB_TYPE
      
      if job["meta"]["error"].to_s == "true"
        puts "ERROR: " + job["meta"]["error_message"].to_s
        raise
      end
      
      # Find existing game object
      game_id = job["meta"]["passthru"]["game_id"]
      
      raise if game_id.nil?
      
      game_id = game_id.to_s.to_i
      game = Game.find(game_id)
      
      raise if game.nil?
      
      # Save thumbnail objects
      screenshots = job["screenshots"]["storage_ids"]
      unless screenshots.nil? or screenshots.length == 0 or game.nil?
        screenshots.each do |object_id|
          # Save Thumbnail object
          thumb = Thumbnail.new
          thumb.width = job["screenshots"]["width"]
          thumb.height = job["screenshots"]["height"]
          thumb.storage_object_id = object_id
          thumb.game = game
          thumb.save
          # Set Game default
          if object_id == job["screenshots"]["default"]
            puts "Found default! Setting to #{object_id}"
            game.thumbnail = thumb
            game.save
          end
        end
      end
      
      puts "Done. Added thumbnails and updated game object."
    end
    
    
    def clean_by_prefix( prefix )
      FileUtils.remove( Dir[ prefix + "*" ] ) unless prefix.include? "../"
    end
    
    
    def cleanup( local_path, screenshots_prefix )
      unless local_path.include? "../"
        FileUtils.remove(local_path) if File.exists?(local_path)
        clean_by_prefix( screenshots_prefix )
      end
    end 
    
end

s3_config = YAML::load(File.open '../config/amazon_s3.yml')['production']

processor = Processor.new s3_config['access_key_id'], s3_config['secret_access_key']

begin
  processor.start
rescue
  processor.recover
  puts "Recovered from error: " + $@.to_s
  puts "Restarting loop."
  retry
end
