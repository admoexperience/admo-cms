class App
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Extensions::Hash::IndifferentAccess

  field :name,              type: String
  field :description,       type: String

  field :last_published_at, type: Time
  field :base_path, type: String

  slug do |obj|
    #Make the slug in the format  $account-$name
    x = obj.name.to_url
    x = obj.admo_account.name.to_url+'-'+x if obj.admo_account
    x
  end

  belongs_to :admo_account
  belongs_to :template

  validates_presence_of :name
  validates_presence_of :admo_account
  validates_uniqueness_of :name, :scope => :admo_account
  validates_uniqueness_of :pod_name, :scope => :admo_account

  field :pod_uid, type: String
  field :pod_name, type: String
  file_accessor :pod

  validates_size_of :pod, :maximum =>  25.megabytes
  validates_property :mime_type, :of => :pod, :in => %w(application/zip)

  field :pod_checksum, type: String

  #Automatically set the checksum of the pod file
  before_save do |document|
    if document.pod && document.pod.tempfile
      document.pod_checksum = Digest::SHA256.file( document.pod.tempfile).hexdigest
    end
  end

  def pod_public_url
    pod.remote_url(expires: 5.hours.from_now, scheme: 'https')  if pod
  end
end
