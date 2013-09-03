require 'dragonfly'
app = Dragonfly[:images]

app.configure_with(:imagemagick)
app.configure_with(:rails)
app.configure do |c|
  c.log = Logger.new($stdout)
  if Rails.env.production?
    c.datastore = Dragonfly::DataStorage::S3DataStore.new(
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

