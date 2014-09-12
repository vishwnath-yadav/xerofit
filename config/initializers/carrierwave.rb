if defined?(CarrierWave)

  CarrierWave.configure do |config|
    config.aws_bucket = Settings.aws.bucket
    config.aws_acl = :private
    config.aws_authenticated_url_expiration = 60 * 60 * 24
    config.aws_credentials = {
        access_key_id: Settings.aws.access_key_id,
        secret_access_key: Settings.aws.secret_access_key
    }
    # config.fog_attributes = {'Content-Disposition' => 'attachment'}

    if Rails.env.test?
      config.storage = :file
    else
      config.storage = :aws
    end
  end

end