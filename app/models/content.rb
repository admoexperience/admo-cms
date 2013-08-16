class Content
  include Mongoid::Document
  include Mongoid::Timestamps

  field :last_published_at,    type: Time, :default => lambda {Time.now}
  field :last_edited_at,       type: Time, :default => lambda {Time.now}
  field :mimetype,             type: String
  field :key,                  type: String


  belongs_to :app

  validates_presence_of :app

  field :value_uid, type: String

  field :value_name, type: String
  file_accessor :value

  index({ app: 1 }, {name: "app_index" })


  def mimetype_enum
    all_status = {
      'application/javascript' => 'Javascript',
      'application/json' => 'Json',
      'x-admo/db-content' => 'Content Reference'
    }
    all_status.map{|key, val| [val, key]}
  end

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

end
