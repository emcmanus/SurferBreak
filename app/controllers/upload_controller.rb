class UploadController < ApplicationController
  
  before_filter :require_user, :only => [:show]
  
  
  def show
    @upload_url = "http://#{S3Keys::S3Config.bucket}.s3.amazonaws.com/"
  end
  
  
  def finish_upload
    
  end
  
  
  def get_upload_key
    
    # Return a policy file with an object key we know to be unique
    # We do this for each new file, to ensure we don't overwrite an existing object on S3
    
    if current_user.nil?
      render :json => { "error" => "Must log in." }, :status => 401
    end
    
    
    ####################################################
    # Debug
    
    @game = Game.new
    @game.original_filename = params[:name]
    @game.user = current_user
    @game.save
    
    ####################################################
    
    
    bucket            = S3Keys::S3Config.bucket
    access_key_id     = S3Keys::S3Config.access_key_id
    secret_access_key = S3Keys::S3Config.secret_access_key
    
    require 'digest/md5'
    
    # We'll use the user's session key to generate the S3 object key
    unique_key      = Digest::MD5.hexdigest( current_user.perishable_token + current_user.single_access_token ) # Auth required to hit this action
    key             = ENV['RAILS_ENV'] + '/' + unique_key
    acl             = 'public-read'
    expiration_date = 10.hours.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z')
    max_filesize    = 25.megabyte
    
    
    policy = Base64.encode64(
      "{'expiration': '#{expiration_date}',
        'conditions': [
          {'bucket': '#{bucket}'},
          ['starts-with', '$key', '#{key}'],
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
    
    @post = {
      "key" => "#{key}/${filename}",
      "AWSAccessKeyId" => "#{access_key_id}",
      "acl" => "#{acl}",
      "policy" => "#{policy}",
      "signature" => "#{signature}",
      "success_action_status" => "201"
    }

    render :json => @post.to_json
  end
end