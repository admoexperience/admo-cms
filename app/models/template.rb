class Template
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Extensions::Hash::IndifferentAccess

  field :name,              type: String
  field :description,       type: String

  validates_uniqueness_of :name
  validates_presence_of :name

  field :pod_uid, type: String
  field :pod_name, type: String
  file_accessor :pod

  validates_size_of :pod, :maximum =>  25.megabytes
  validates_property :mime_type, :of => :pod, :in => %w(application/zip)
end
