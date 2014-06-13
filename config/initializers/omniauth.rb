require "omniauth-facebook"
Rails.application.config.middleware.use OmniAuth::Builder do
  
  provider :facebook, FACEBOOK_KEY, FACEBOOK_SECRET, :scope => 'email,read_stream', :display => 'popup'
  provider :google_oauth2, APP_ID, APP_SECRET_ID, scope: 'userinfo.email, userinfo.profile'
  provider :twitter, TWITTER_KEY, TWITTER_SECRET
end