class UploadController < ApplicationController
  
  before_filter :require_user, :only => [:show]
  
  
  # Flow for two files:
  # show -> get_key -> file_sent -> get_key -> file_sent -> publish
  
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
    @upload_url = Game.s3_bucket_path
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
    
    if current_user.nil? or current_user.id.nil?
      @error = true
      @error_message = "Must log in."
    end
    
    bucket            = S3Keys::S3Config.bucket
    access_key_id     = S3Keys::S3Config.access_key_id
    secret_access_key = S3Keys::S3Config.secret_access_key
    
    require 'digest/md5'
    
    # Use the user's session key to generate the S3 object key
    expiration_date = 10.hours.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z')
    unique_key      = Digest::MD5.hexdigest( current_user.id + ("%10.6f" % Time.now.to_f) ) # Auth required to hit this action
    acl             = 'public-read'
    max_filesize    = 25.megabyte
    
    
    policy = Base64.encode64(
      "{'expiration': '#{expiration_date}',
        'conditions': [
          {'bucket': '#{bucket}'},
          {'key': '#{Game.s3_directory}/#{unique_key}'},
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
      "key" => "#{Game.s3_directory}/#{unique_key}",
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
  
  
  
  def file_sent     # Successfully uploaded a file to S3
    # Required params
    if params[:upload_id].nil? or params[:name].nil?
      flash[:notice] = "Invalid parameters"
      redirect_to :action => "show"
      return
    end
    
    @game = Game.find_by_storage_object_id( params[:upload_id] )
    
    # Verify user
    if @game.nil? or @game.user != current_user
      render :json => { "success" => false }.to_json, :status => 401
      return
    end
    
    @game.is_uploaded = true  # Model handles thumbnail generation
    
    if @game.save
      render :json => { "success" => true }.to_json
    else
      render :json => { "success" => false }.to_json, :status => 401
    end
  end
  
  
  
  def old_file_finished
    
    # EARLY EXITS BELOW
    
    # Required params
    if params[:upload_id].nil? or params[:name].nil?
      flash[:notice] = "Invalid parameters"
      redirect_to :action => "show"
      return
    end
    
    # S3 successfully received single file
    @game = Game.find_by_storage_object_id( params[:upload_id] )
    
    # Verify user
    if @game.nil? or @game.user != current_user
      render :json => { "success" => false }.to_json, :status => 401
      return
    end
    
    # End prereq
    
    # Later we'll need to check the file header to determine which platform the ROM belongs to.
    # For now, we're going to download the ROM to a tmp folder for synchronous processing.
    # This will have to change as we allow the application to handle multiple platforms and make
    # screenshot generation an asynchronous process.
    
    # Update is_uploaded flag
    @game.is_uploaded = true
    
    # Thumbnail Paths
    # remote_rom_path         = "http://#{S3Keys::S3Config.bucket}.s3.amazonaws.com/uploads/" + @game.storage_object_id
    # local_rom_path          = "#{RAILS_ROOT}/tmp/roms/#{@game.storage_object_id}"
    # local_screenshot_dir    = "#{RAILS_ROOT}/tmp/screenshots/#{@game.storage_object_id}"
    # local_screenshot_prefix = "#{local_screenshot_dir}/#{@game.storage_object_id}"
    
    # Create necessary directories
    Dir.mkdir(local_screenshot_dir) unless File.exists?(local_screenshot_dir)
    
    # TODO - move to environment variable
    binary_root_path = "#{RAILS_ROOT}/bin/os-x/"
    
    # Create local copy
    cmd_get_file  = `wget #{remote_rom_path} -O #{local_rom_path}`
    
    # Build screenshots - 15 second timeout
    require 'timeout'
    
    cmd_generate_thumbs = ""
    thumb_timeout = true
    
    begin
      timeout(15) {
        puts "#{binary_root_path}screen_grabber #{local_rom_path} #{local_screenshot_prefix}\n"
        cmd_generate_thumbs = (`#{binary_root_path}screen_grabber #{local_rom_path} #{local_screenshot_prefix}`).strip
      }
      thumb_timeout = false
    rescue Timeout::Error
      # TODO - timeout. Assign default thumbnail
    end
    
    # TODO - check for existance of thumbnails (and file size?)
    
    
    # Prepare for upload
    require 'aws/s3'
    
    AWS::S3::Base.establish_connection!(
      :access_key_id     => S3Keys::S3Config.access_key_id,
      :secret_access_key => S3Keys::S3Config.secret_access_key
    )
    
    
    # Thumbnail Processing
    
    if not thumb_timeout
      # cmd_generate_thumbs contains the suggested default
      (0..19).each do |index|
        current_thumb_path = format("%s%.5i.png", local_screenshot_prefix, index)
        current_storage_id = format("%s%.5i.png", @game.storage_object_id, index)
        
        # Upload thumbnail
        AWS::S3::S3Object.store("screenshots/#{current_storage_id}", open(current_thumb_path),
                        S3Keys::S3Config.bucket, :access => :public_read)
        
        # Build thumbnail object
        thumb = Thumbnail.new
        thumb.width = 224
        thumb.height = 256
        thumb.game = @game
        thumb.storage_object_id = current_storage_id
        thumb.save  # TODO - confirm success
        
        if current_thumb_path == cmd_generate_thumbs
          @game.thumbnail = thumb
        end
      end
    end
    
    # Cleanup:
    # Screenshot directory
    # Screenshot files
    # ROM Cache
    
    # cmd_delete_cache    = `rm /tmp/roms/#{@game.storage_object_id}`
    
    # Persist thumbnails
    # for 0...19.each do |i|
    #   @thumb = Thumbnail.new
    #   @thumb.width = 256  # TODO - adjust based on platform
    #   @thumb.height = 224 # TODO - ^^^
    #   @thumb.storage_object_id = "blah" # TODO adjust for naming convention -- should just be game.filename + index + png
    #   @thumb.game = @game
    # end
    
    # Read the external program's output, which will specify which image it thinks makes the best default
    # @default_thumb = Thumbnail.find_by_storage_object_id
    
    # Save changes to game object
    success = @game.save
    
    render :json => { "success" => true }.to_json
    
    # if not @game.nil? and @game.user == current_user
    #   @game.is_uploaded = true
    #   render :json => { "success" => true }.to_json
    # else
    #   render :json => { "success" => false }.to_json, :status => 401
    # end
  end
  
  
end