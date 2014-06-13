require "omniauth-facebook"
Rails.application.config.middleware.use OmniAuth::Builder do
  
  # provider :facebook, "1441124259474236", "93b2c340b13ed77606c4d2b5129b9381", :scope => 'email,read_stream', :display => 'popup'
  provider :facebook, "1495361647345455", "1d605640672025bd2f184072a150ea89", :scope => 'email,read_stream', :display => 'popup'
  # provider :google_oauth2, "1044996955605-gr0lvpu3ejbf4jlc2ghh3ut3vt78h8er.apps.googleusercontent.com", "EiJx0W5quLsbidRx-n2Y6AyE", scope: 'userinfo.email, userinfo.profile'
  provider :google_oauth2, "1055695204606-kas71rqieg1e0fsguvhekum2eo4lgd4g.apps.googleusercontent.com", "ZJha_iPwdCt0KzQMbkYEzK9I", scope: 'userinfo.email, userinfo.profile'
  provider :twitter, "OfWiBajwBXc5SMdR5fDxfR6O7", "ig8B2noq4szAMMKAuzn37ssT98bB7ZDRPZy8FeFCy0K6zSxbEz"
end