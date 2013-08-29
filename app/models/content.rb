class Content
  include Mongoid::Document
  include Mongoid::Timestamps

  field :last_published_at,    type: Time, :default => lambda {Time.now}
  field :last_edited_at,       type: Time, :default => lambda {Time.now}
  field :key,                  type: String


  belongs_to :app

  validates_presence_of :app

  field :value_uid, type: String

  field :value_name, type: String
  file_accessor :value

  index({ app: 1 }, {name: "app_index" })

  def publish_change
    ContentUploaderJob.new.process(self)
  end

  def upload_worker
    Rails.logger.info "Uploading "+ self.key
    self.value.file do |tempfile|
      dbox = DropboxUploader.new(self.app.admo_account.dropbox_session_info)
      dbox.upload(File.join(self.app.base_path,self.key),tempfile)
      self.last_published_at = Time.now
      self.save!
    end
  end

  def is_image
    File.extname(self.key) =~ /jpg|jpeg|png|gif/i if self.key
  end

  def thumb_url
    if self.is_image
      self.value.thumb('200x200').url
    else
      nil
    end
  end

  #one convenient method to pass jq_upload the necessary information
  def to_jq_upload
    {
      "name" => read_attribute(:value_name),
      "size" => value.size,
      "url" => value.url,
      "thumbnail_url" => thumb_url
    }
  end
end
