class Template
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,              type: String
  field :description,       type: String

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

  #Automatically set the checksum of the pod file
  before_save do |document|
    if document.pod && document.pod.tempfile
      document.pod_checksum = Digest::SHA256.file( document.pod.tempfile).hexdigest
    end
  end
end
