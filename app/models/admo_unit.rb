class AdmoUnit
  include Mongoid::Document
  include Mongoid::Timestamps

  CONFIG_KEYS = %w(
    app
    kinnect_elevation
  ).freeze


  field :api_key,          type: String,   :default => lambda {SecureRandom.uuid}
  field :name,             type: String
  field :config,           type: Hash,     :default => {}
  field :last_checkin,     type: Time,     :default => nil

  validates_uniqueness_of :api_key
  validates_uniqueness_of :name
  validates_presence_of :name

  def checkin
    self.last_checkin = Time.now()
    self.save
  end

  def set_config(key,value)
    raise "Invalid config key please use allowed values" unless CONFIG_KEYS.include? key
    hash = self.config
    hash[key] = value
    self.config = hash
    self.save
    self.publish_change
  end


  def publish_change
    #Only send push notifications in prod mode
    return if Rails.env.development?

    pubnub = Pubnub.new(
      :publish_key=> 'pub-c-806ef41c-8fdb-45c9-8ddd-da053b45a04a',
      :subscribe_key=>'sub-c-5811c59e-bbce-11e2-846b-02ee2ddab7fe',
      :secret_key    => nil,    # optional, if used, message signing is enabled
      :cipher_key    => nil,    # optional, if used, encryption is enabled
      :ssl           => false     # true or default is false)
    )

    pubnub.publish({
      :channel => self.api_key,
      :message => 'update',
      :callback => lambda { |message| }
    })
  end
end
