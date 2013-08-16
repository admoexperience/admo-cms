require 'dragonfly'
app = Dragonfly[:images]

app.configure_with(:imagemagick)
app.configure_with(:rails)
app.configure do |c|
  c.log = Logger.new($stdout)
  if Rails.env.production?
    c.datastore = Dragonfly::DataStorage::S3DataStore.new(
      :bucket_name => ENV['S3_BUCKET'],
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    )
  end
end

#See
app.define_macro_on_include(Mongoid::Document, :image_accessor)
app.define_macro_on_include(Mongoid::Document, :file_accessor)

