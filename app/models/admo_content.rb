class AdmoContent
  include Mongoid::Document
  include Mongoid::Timestamps

  field :type,             type: String
  field :key,              type: String
  field :value,            type: String

  belongs_to :admo_app

  validates_presence_of :admo_app

  index({ admo_app: 1 }, {name: "admo_app_index" })


  def type_enum 
      ['File.js', 'File.raw', 'File.s3'] 
   end 
end
