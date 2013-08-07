class AdmoImage
  include Mongoid::Document
  include Mongoid::Timestamps


  belongs_to :admo_unit

  field :image_uid
  field :image_name
  field :tags
  image_accessor :image

  validates_size_of :image, :maximum =>  5.megabytes
  validates_property :mime_type, :of => :image, :in => %w(image/jpeg image/jpg image/png image/gif)
  validates_presence_of :image


  validates_presence_of :admo_unit


  #Deletes the image from the data store when this model is deleted
  before_destroy do
    image.destroy!
  end

  def thumbnail_url
    #doesn't include hostname, also append the filename at the end to get the original name + ext
    self.image.thumb('100x100>').url + '/' + self.image_name
  end

  #Not super nice
  def upload_to_dropbox(imagefile)
    dbox = DropboxUploader.new(self.admo_unit.dropbox_session_info)
    folder = self.admo_unit.get_config['dropbox_path'] || raise("Missing dropbox_path config variable")
    dbox.upload_file(folder, imagefile, self.image_name)
  end
end
