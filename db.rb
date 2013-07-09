# This references the Dropbox SDK gem install with "gem install dropbox-sdk"
require 'dropbox_sdk'

# Get your app key and secret from the Dropbox developer website
APP_KEY = 'tk4cmq6x6jcag2r'
APP_SECRET = '4shy35r9jhgssqf'

 # ACCESS_TYPE should be ':dropbox' or ':app_folder' as configured for your app
 ACCESS_TYPE = :dropbox

# session = DropboxSession.new(APP_KEY, APP_SECRET)

# //session.get_request_token

# //authorize_url = session.get_authorize_url

# # Make the user sign in and authorize this token
# puts "AUTHORIZING", authorize_url
# puts "Please visit that web page and hit 'Allow', then hit Enter here."
# gets

# # This will fail if the user did not visit the above URL and hit 'Allow'
# session.get_access_token
session_info = <<DOC
---
- cbjq0alp9qks81l
- 06uktj96rwmim6ns
- UrE2Nvh7OLCjRMFj
- 2mex2T4PJ7sAXJcs
- 4shy35r9jhgssqf
- tk4cmq6x6jcag2r
DOC

session = DropboxSession.deserialize(session_info)


client = DropboxClient.new(session, ACCESS_TYPE)
#puts "linked account:", client.account_info().inspect

file_metadata = client.metadata('/magnum-opus.txt')
puts "metadata:", file_metadata.to_yaml


puts "cursor stuff:  "
puts client.delta("AAFIqLLWgx34bp6TUZWV1fqQ7LJVuADJUf1UextA_SN1MX0FkMBY8yZYY5jjnm6_janRJLRxLFp2XJUPfjVHIHl4h2_256F4MQeMUV1Foj2OD0njXg3_c0QY2yPdtJXOUpRqiVLznoMj2K-MJyfp8LII").to_yaml


file = open('working-draft.txt')
#response = client.put_file('/magnum-opus.txt', file)
#puts "uploaded:", response.inspect

