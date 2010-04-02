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
require 'daemons'


debug = false
environment = "production"

for i in (0...(ARGV.count)) do
  if ARGV[i].include? "debug"
    debug = true
  elsif ARGV[i].include? "environment"
    environment = ARGV[i+1]
    i += 1
  elsif ARGV[i].to_s.include? "help"
    puts "Usage: ./sqs_poller.rb [--debug] [--environment development]\n"
    puts "Debug runs poller as a non-daemon process."
    puts "Environment specifies which parameters to pick from the config."
    exit
  end
end


# Get path to log file before daemonizing
log_file = File.expand_path(File.dirname(__FILE__)).to_s + "/sqs_poller_#{environment}.log"

if debug
  logger = Logger.new STDOUT
  logger.info "Starting in debug mode."
else
  puts "Starting daemon."
  Daemons.daemonize
  logger = Logger.new log_file, 10, 1024000
  logger.info "Poller started."
end



# Constants

MAX_API_VERSION   = 1
JOB_TYPE          = "thumbnail_generation"


require "../config/environment"


class Processor
  
  def initialize( access_key_id, secret_access_key, logger )
    sqs = RightAws::SqsGen2.new access_key_id, secret_access_key
    @todo_queue = sqs.queue "UploadProcessingTodo"
    @done_queue = sqs.queue "UploadProcessingDone"
    
    @logger = logger
    
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
  
  
  def recover
    # Update file_processed, if possible
    @logger.info "Attempting to update Game object."
    
    begin
      job = JSON.parse @job.body
    rescue JSON::ParserError
      raise
    end
    game_id = job["meta"]["passthru"]["game_id"]
    if game_id
      game = Game.find(game_id.to_i)
      game.file_processed = true
      game.save
    end
  end
  
  
  private
    
    def process
      
      begin
        job = JSON.parse @job.body
      rescue JSON::ParserError
        raise
      end
      
      @logger.info "Received finished job: #{@job.body}"
      
      raise if job["meta"]["api_version"] > MAX_API_VERSION
      raise if job["meta"]["job_type"] != JOB_TYPE
      
      if job["meta"]["error"].to_s == "true"
        @logger.error "ERROR: " + job["meta"]["error_message"].to_s
        recover
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
        screenshots.each_with_index do |object_id, index|
          # Save Thumbnail object
          thumb = Thumbnail.new
          thumb.width = job["screenshots"]["width"]
          thumb.height = job["screenshots"]["height"]
          thumb.storage_object_id = object_id
          thumb.game = game
          thumb.save
          # Set Game default
          if object_id == job["screenshots"]["default"]
            @logger.info "Found default! Setting to #{object_id}"
            game.thumbnail = thumb
          end
          if index == (screenshots.length - 1)
            # No match exists
            unless game.thumbnail
              @logger.error "Could not find a default thumbnail."
            end
          end
        end
      end
      
      game.file_processed = true
      game.save
      
      @logger.info "Done. Added thumbnails and updated game object."
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

s3_config = YAML::load(File.open '../config/amazon_s3.yml')[environment]

processor = Processor.new s3_config['access_key_id'], s3_config['secret_access_key'], logger

begin
  processor.start
rescue Exception => e
  logger.warn "Recovered from error:\n#{e.inspect}\n#{$@}\n#{e.backtrace}"
  begin
    processor.recover
  rescue Exception => exception
    logger.error "Recover failed."
    logger.error "Recovery error was:\n#{exception.inspect}\n#{$@}\n#{exception.backtrace}"
  end
  logger.warn "Restarting loop."
  retry
end
