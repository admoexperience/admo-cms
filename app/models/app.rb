class App
  include Mongoid::Document
  include Mongoid::Timestamps


  field :name,              type: String
  field :description,       type: String
  #This is yet another hack
  field :config,            type: Hash,  :default => {
    'top_left'=>{
        'title'=> '',
        'description'=>''
      },
    'top_right'=>{
        'title'=>'',
        'description'=>''
      },
    'bottom_left'=>{
        'title'=> '',
        'description'=>''
      },
      'bottom_right'=>{
        'title'=> '',
        'description'=>''
      }
  }

  field :template, type: String
  field :last_published_at, type: Time
  field :base_path, type: String

  belongs_to :admo_account
  has_many :contents

  validates_uniqueness_of :name
  validates_presence_of :name

  class Binder
    def initialize(config)
      @config = config
    end
    def get_binding # this is only a helper method to access the objects binding method
      binding
    end
  end

  def compiled_template
    b = Binder.new(self.config)
    template = ERB.new self.template
    template.result(b.get_binding)
  end

   def publish_change
    ContentUploaderJob.new.process(self)
  end

  def upload_worker
    tempfile = StringIO.open(compiled_template)
    dbox = DropboxUploader.new(self.admo_account.dropbox_session_info)
    dbox.upload(File.join(self.base_path,'data','musicmoods-data.js'),tempfile)
    self.last_published_at = Time.now
    self.save!
    self.last_published_at = Time.now
    self.contents.each do |m|
      m.publish_change if m.last_published_at < m.last_edited_at
    end
  end
end
