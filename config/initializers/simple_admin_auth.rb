Rails.application.config.middleware.use SimpleAdminAuth::Builder do
  provider :google_apps, :domain => 'fireid.com', :name => 'admin'
end