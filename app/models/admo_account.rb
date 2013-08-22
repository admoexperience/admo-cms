class AdmoAccount
  include Mongoid::Document
  include Mongoid::Timestamps

  field :api_key,          type: String,   :default => lambda {SecureRandom.uuid}
  field :name,             type: String
  field :config,           type: Hash,     :default => {}

  #This is a total hack, but for now its ok...
  #We need a generic blob of auth info that can be encrypted
  #It also needs to be different for TVR/scala and stuff but setup that when know that info
  field :dropbox_session_info,   type: String,   :default=> ''

  has_many :admo_units
  has_many :apps

  validates_uniqueness_of :api_key
  validates_uniqueness_of :name
  validates_presence_of :name

  index({ api_key: 1 }, { unique: true, name: "api_key_index" })


  def publish_change
    #If the account config changes publish it to all units
    self.admo_units.each do |unit|
      unit.publish_change
    end
  end
end
