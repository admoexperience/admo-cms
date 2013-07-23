#Script allows you to request new dropbox secret session info

require 'dropbox_sdk'

# Get your app key and secret from the Dropbox developer website
APP_KEY = ENV['DBOX_APP_KEY'] || (raise 'Please set the DBOX_APP_KEY env var')
APP_SECRET = ENV['DBOX_APP_SECRET']|| (raise 'Please set the DBOX_APP_SECRET env var')

# ACCESS_TYPE should be ':dropbox' or ':app_folder' as configured for your app
ACCESS_TYPE = :dropbox

session = DropboxSession.new(APP_KEY, APP_SECRET)

session.get_request_token

authorize_url = session.get_authorize_url

# # Make the user sign in and authorize this token
puts "AUTHORIZING", authorize_url
puts "Please visit that web page and hit 'Allow', then hit Enter here."
gets
session.get_access_token

puts session.serialize()
