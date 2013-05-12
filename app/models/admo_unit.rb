class AdmoUnit
  include Mongoid::Document
  include Mongoid::Timestamps


  field :api_key,          type: String,   :default => lambda {SecureRandom.uuid}
  field :name,             type: String
  field :last_checkin,     type: Time,     :default => nil

  validates_uniqueness_of :api_key
  validates_uniqueness_of :name
  validates_presence_of :name

  def checkin
    self.last_checkin = Time.now()
  end

end
