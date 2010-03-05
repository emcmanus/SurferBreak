class UploadController < ApplicationController
  
  before_filter :require_user, :only => [:show]
  
  # Flow for two files:
  # show -> get_key -> file_finished -> get_key -> file_finished -> publish
  
  # For each file the user hits get_key, which returns the policy file and the S3 key which acts as an upload receipt
  # For each finished upload the user hits file_finished, which verifies ownership and sets is_uploaded to true
  # When all uploads are finished the user is taken to publish, which displays all unpublished files
  
  
  def html_uploader
    # TODO
  end
  
  
  def html_uploader_finish
    # TODO
  end
  
  
  def show
    @upload_url = "http://#{S3Keys::S3Config.bucket}.s3.amazonaws.com/"
  end
  
  
  def file_finished
    if params[:name].nil?
      redirect_to :action => "show"
    else
      # S3 successfully received single file
      @game = Game.find_by_storage_object_id( params[:upload_id] )
      
      # Verify ownership, update "is_uploaded"
      if not @game.nil? and @game.user == current_user
        @game.is_uploaded = true
        render :json => { "success" => true }.to_json
      else
        render :json => { "success" => false }.to_json, :status => 401
      end
    end
  end
  
  
  def publish
    # Find all unpublished games for this user, display metadata forms for each
    # @unpublished_games = Game.find( ... )
  end
  
  
  def generate_policy
    
    # Return a policy file with an object key we know to be unique
    # We do this for each new file, to ensure we don't overwrite an existing object on S3
    
    @error = false
    @error_message = ""
    
    if current_user.nil?
      @error = true
      @error_message = "Must log in."
    end
    
    bucket            = S3Keys::S3Config.bucket
    access_key_id     = S3Keys::S3Config.access_key_id
    secret_access_key = S3Keys::S3Config.secret_access_key
    
    require 'digest/md5'
    
    # We'll use the user's session key to generate the S3 object key
    unique_key      = Digest::MD5.hexdigest( current_user.perishable_token + current_user.single_access_token ) # Auth required to hit this action
    acl             = 'public-read'
    expiration_date = 10.hours.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z')
    max_filesize    = 25.megabyte
    
    
    policy = Base64.encode64(
      "{'expiration': '#{expiration_date}',
        'conditions': [
          {'bucket': '#{bucket}'},
          {'key': 'uploads/#{unique_key}'},
          {'acl': '#{acl}'},
          {'success_action_status': '201'},
          ['starts-with', '$Filename', ''],
          ['content-length-range', 0, #{max_filesize}]
        ]
      }").gsub(/\n|\r/, '')
    
    signature = Base64.encode64(
                  OpenSSL::HMAC.digest(
                    OpenSSL::Digest::Digest.new('sha1'),
                    secret_access_key, policy)).gsub("\n","")
    
    @post_params = {
      "key" => "uploads/#{unique_key}",
      "AWSAccessKeyId" => "#{access_key_id}",
      "acl" => "#{acl}",
      "policy" => "#{policy}",
      "signature" => "#{signature}",
      "success_action_status" => "201"
    }
    
    @uploader_params = {
      "policy_file" => @post_params,
      "upload_id" => "#{unique_key}"
    }
    
    # Check for existing key
    
    if Game.exists?( :storage_object_id => unique_key )
      @error = true
      @error_message = "Found duplicate key."
    end
    
    
    # Save game object
    
    if not @error
      @game = Game.new
      @game.original_filename = params[:name]
      @game.title = params[:name].chomp(File.extname(params[:name])).humanize.titleize # Title suggestion
      @game.storage_object_id = unique_key  # path will later be prefixed by "uploads/"
      @game.user = current_user
      
      @error = true unless @game.save
    end
    
    
    if @error == true
      if @error_message.empty?
        logger.error( "Upload error in generate_policy: Generic error. May be that the generated key wasn't unique." )
        render :json => { "error" => "Please try your upload again." }, :status => 401
      else
        logger.error( "Upload error in generate_policy: #{@error_message}" )
        render :json => { "error" => @error_message }, :status => 401
      end
    else
      render :json => @uploader_params.to_json
    end
    
  end
end