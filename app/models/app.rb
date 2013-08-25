class App
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,              type: String
  field :description,       type: String
  #This is yet another hack
  field :config,            type: Hash,  :default => {
    'key1'=>{
      'subkey1'=>'value1'
    }
  }

  field :last_published_at, type: Time
  field :base_path, type: String

  belongs_to :admo_account
  has_many :contents

  validates_uniqueness_of :name
  validates_presence_of :name

  def publish_change
    ContentUploaderJob.new.process(self)
  end

  def config_as_json
    JSON.pretty_generate(self.config)
  end

  def upload_worker
    tempfile = StringIO.open(config_as_json)
    dbox = DropboxUploader.new(self.admo_account.dropbox_session_info)
    dbox.upload(File.join(self.base_path,'data','data.json'),tempfile)
    self.last_published_at = Time.now
    self.save!
    self.last_published_at = Time.now
    self.contents.each do |m|
      m.publish_change if m.last_published_at < m.last_edited_at
    end
  end
end