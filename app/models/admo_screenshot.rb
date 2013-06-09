class AdmoScreenshot
  include Mongoid::Document
  include Mongoid::Timestamps


  belongs_to :admo_unit

  field :image_uid
  field :image_name
  image_accessor :image 

  image_accessor :image

  validates_size_of :image, :maximum =>  5.megabytes
  validates_property :mime_type, :of => :image, :in => %w(image/jpeg image/jpg image/png image/gif)
  validates_presence_of :image

  
  validates_presence_of :admo_unit


  #Deletes the image from the data store when this model is deleted
  before_destroy do
    image.destroy!
  end
end


