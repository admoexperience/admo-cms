require 'dragonfly'
app = Dragonfly[:images]

app.configure_with(:imagemagick)
app.configure_with(:rails)
app.configure do |c|
  c.url_host = Settings.general.protocol+'://'+Settings.general.hostname
  c.log = Logger.new($stdout)
  if Settings.s3.region and Settings.s3.bucket_name and Settings.s3.access_key_id and Settings.s3.secret_access_key
    c.datastore = Dragonfly::DataStorage::S3DataStore.new(
      #Mark the files as private by default.
      #NO idea why this isn't the default
      :storage_headers => {'x-amz-acl' => 'private'},
      :region=>Settings.s3.region,
      :bucket_name => Settings.s3.bucket_name,
      :access_key_id => Settings.s3.access_key_id,
      :secret_access_key => Settings.s3.secret_access_key
    )
  end
end

#See
app.define_macro_on_include(Mongoid::Document, :image_accessor)
app.define_macro_on_include(Mongoid::Document, :file_accessor)

