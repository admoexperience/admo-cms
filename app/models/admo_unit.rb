class AdmoUnit
  include Mongoid::Document
  include Mongoid::Timestamps

  CONFIG_KEYS = %w(
    app
    kinect_elevation
    environment
    web_ui_server
  ).freeze


  field :api_key,          type: String,   :default => lambda {SecureRandom.uuid}
  field :name,             type: String
  field :config,           type: Hash,     :default => {}
  field :last_checkin,     type: Time,     :default => nil

  has_many :admo_screenshots

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

  #Function cleans up older screenshots
  def clean_up
    #Delete every thing but the most recent 5 screenshots
    screenshots = self.admo_screenshots.order_by("updated_at DESC").limit(5)
    self.admo_screenshots.each  do |screen|
      unless screenshots.include? screen
        screen.destroy
      end
    end
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
