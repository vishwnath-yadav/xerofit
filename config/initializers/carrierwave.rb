if defined?(CarrierWave)

  CarrierWave.configure do |config|
    # config.aws_bucket = Settings.aws.bucket
    # config.aws_acl = :private
    # config.aws_authenticated_url_expiration = 60 * 60 * 24
    # config.aws_credentials = {
    #     access_key_id: Settings.aws.access_key_id,
    #     secret_access_key: Settings.aws.secret_access_key
    # }
    # config.aws_attributes = {'Content-Disposition' => 'attachment'}
      
    config.fog_credentials = {
      :provider               => 'AWS',                        
      :aws_access_key_id      => Settings.aws.access_key_id,                        
      :aws_secret_access_key  => Settings.aws.secret_access_key                        
    }
    config.fog_directory  = Settings.aws.bucket                     # required
    config.fog_public     = false                                   # optional, defaults to true
    config.fog_attributes = {'Content-Disposition' => 'attachment'}
      if Rails.env.test?
        config.storage = :file
      else
        config.storage = :fog
      end
  end

end