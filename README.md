Getting started
---------------

### Install Mongodb + imagemagick ###

On OSX:

    brew update
    brew install mongodb
    brew install imagemagick

Install [rbenv](https://github.com/sstephenson/rbenv) and [ruby-build](https://github.com/sstephenson/ruby-build)


# Configuration #

The following is provided by the `rails_config` gem.

Config entries are compiled from:

    config/settings.yml
    config/settings/#{environment}.yml

    config/settings.local.yml
    config/settings/#{environment}.local.yml

Settings defined in files that are lower in the list override settings higher. All `*.local.yml` files can be created per
developer because they are `.gitignored`. All settings can be accessed through the globally defined `Settings` object.

Default settings are defined in `config/settings.yml`.

# Testing

To run all tests

    rspec


## Development setup ##

    rake db:seed

defaults:
  
  * Username: demo@admoexperience.com
  * AdminUser: admin@admoexperience.com
  * Password: demo12345


## Live Reloading ##

    foreman start -f Procfile.dev

This runs `rails s -p 3000` and `guard`

## Api docs ##
Once the server is running you can view the api docs at http://localhost:3000/docs/ which should contain all the configruation options.

Also note the api has been made with [Grape](https://github.com/intridea/grape), [Swagger](https://developers.helloreverb.com/swagger/), [Grape-swagger](https://github.com/tim-vandecasteele/grape-swagger)


## Running on Heroku ##

heroku create
heroku addons:add mongohq
#Some reason production assets are needed
heroku labs:enable user-env-compile 
heroku config:set DEVISE_SECRET_KEY=random36pluscharstring GENERAL_SECRET_KEY=random36pluscharstring

