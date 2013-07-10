require 'omniauth/strategies/google_oauth2'

Rails.application.config.middleware.use SimpleAdminAuth::Builder do
  # The name must be `admin`
  provider :google_oauth2, '881670856555.apps.googleusercontent.com', 'DB3b4_DYi8PDzZRFEakrqlzf', name: 'admin',
          access_type: 'online', hd: 'fireid.com', approval_prompt: 'auto'
end
