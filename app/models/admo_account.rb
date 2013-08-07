class AdmoAccount
  include Mongoid::Document
  include Mongoid::Timestamps

  field :api_key,          type: String,   :default => lambda {SecureRandom.uuid}
  field :name,             type: String
  field :config,           type: Hash,     :default => {}

  has_many :admo_units

  validates_uniqueness_of :api_key
  validates_uniqueness_of :name
  validates_presence_of :name

  index({ api_key: 1 }, { unique: true, name: "api_key_index" })
end
