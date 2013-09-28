Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dropbox, Settings.dropbox.key, Settings.dropbox.secret
end
OmniAuth.config.logger = Rails.logger