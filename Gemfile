source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '~> 4.0.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development, :test do
  gem 'sqlite3'
  gem 'foreman'
  gem 'pry'
  gem 'rb-fsevent'
  gem 'rspec-rails', '~> 2.0'
  gem 'guard-livereload'
  gem 'rack-livereload'
  gem 'timecop'
  gem 'factory_girl'
end

group :production do
  gem 'pg'
  #Used by heroku to enable logging and other magic
  gem 'rails_12factor'
  #Assets are served in production mode, and cached
  gem 'heroku_rails_deflate'
end

gem 'sass-rails',   '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier', '~> 2.1.2'

gem 'newrelic_rpm'
gem 'jquery-rails'

gem 'thin'
gem 'simple_status'
gem 'simple_admin_auth'
gem 'omniauth-google-oauth2'


gem 'sucker_punch', '~> 1.0.1'
gem 'bson_ext'
gem 'mongoid', github: 'mongoid/mongoid'

gem 'grape'
gem 'grape-swagger', '~>0.6.0'
gem 'grape-rabl'

gem 'pubnub'

gem 'fog'
gem 'dragonfly'

gem 'bugsnag'

gem 'hipchat', '~> 0.11.0'

gem 'rails_admin', '~> 0.5.0'

gem 'mongoid_slug'

gem "mongoid-indifferent-access", require: "mongoid_indifferent_access"

#Had to run my own fork because the jquery load function wasn't happening
#Also wanted the maxwidth/maxheight feature
gem 'rails_admin_map_field',  github: 'drubin/rails_admin_map_field'

gem 'mixpanel_client', '~> 3.1.2'

gem 'devise'

gem 'twitter-bootstrap-rails'

gem 'dropbox-sdk', '~> 1.6.1', require: 'dropbox_sdk'

gem "rails_config", "~> 0.3.3"
