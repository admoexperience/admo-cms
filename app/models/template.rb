class Template
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,              type: String
  field :description,       type: String
  field :status,            type: String, default: 'disabled'

  validates_uniqueness_of :name
  validates_presence_of :name

  field :pod_uid, type: String
  field :pod_name, type: String
  field :pod_checksum, type: String
  file_accessor :pod

  field :thumbnail_image_uid, type: String
  field :thumbnail_image_name, type: String
  image_accessor :thumbnail_image
  validates_size_of :thumbnail_image, :maximum => 1.megabytes

  field :preview_image_uid, type: String
  field :preview_image_name, type: String
  image_accessor :preview_image
  validates_size_of :preview_image, :maximum => 1.megabytes

  validates_size_of :pod, :maximum =>  25.megabytes
  validates_property :mime_type, :of => :pod, :in => %w(application/zip)

  has_many :apps

  #Automatically set the checksum of the pod file
  before_save do |document|
    if document.pod && document.pod.tempfile
      document.pod_checksum = Digest::SHA256.file( document.pod.tempfile).hexdigest
    end
  end

  def status_enum
    ['enabled', 'disabled']
  end

  def enabled?
    status == 'enabled'
  end

  def copied_by_user?(user)
    raise "Expected User but got #{user.inspect}" unless user.is_a?(User)

    user.admo_account.apps.each do |app|
      return true if app.template == self
    end
    return false
  end
end
