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

  validates_size_of :pod, :maximum =>  25.megabytes
  validates_property :mime_type, :of => :pod, :in => %w(application/zip)

  #Automatically set the checksum of the pod file
  before_save do |document|
    if document.pod && document.pod.tempfile
      document.pod_checksum = Digest::SHA256.file( document.pod.tempfile).hexdigest
    end
  end
end
