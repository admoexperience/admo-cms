class AdmoUnit
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Extensions::Hash::IndifferentAccess

  CONFIG_KEYS = %w(
    app
    kinect_elevation
    environment
    web_ui_server
    pod_file
  ).freeze


  field :api_key,          type: String,   :default => lambda {SecureRandom.uuid}
  field :name,             type: String
  field :dropbox_session_info,   type: String,   :default=> ''
  field :config,           type: Hash,     :default => {}
  field :last_checkin,     type: Time,     :default => nil

  field :latitude, type: Float
  field :longitude, type: Float

  field :address, type: String
  field :city, type: String
  field :state, type: String



  has_many :admo_screenshots
  has_many :admo_images

  belongs_to :admo_account

  validates_presence_of :admo_account

  validates_uniqueness_of :api_key
  validates_uniqueness_of :name, :scope=> :admo_account
  validates_presence_of :name

  #Indexes
  index({ api_key: 1 }, { unique: true, name: "api_key_index" })

  def checkin(requestbase)
    self.last_checkin = Time.now()
    self.save
    self.push_to_dashboard(requestbase,self.admo_screenshots.last)
  end

  def push_to_dashboard(requestbase,screenshot)
     return unless self.dashboard_enabled
     #Hack to get it working better, if screenshots aren't there :/ this is horrid coding
     url = ""
     url = "#{requestbase}#{screenshot.image.url}" if screenshot and screenshot.image
     screenshot_created_at = ""
     screenshot_created_at = screenshot.created_at if screenshot
     DashboardNotifyJob.new.process(self.name, {:checkedinAt=>self.last_checkin,:screenshotUrl=> url, :screenshotCreatedAt=> screenshot_created_at})
  end

  def dashboard_enabled
    conf = self.get_config
    return (conf.has_key? 'dashboard_enabled' and conf['dashboard_enabled'])
  end

  def create_screenshot(requestbase, hash)
    screenshot = self.admo_screenshots.create!(hash)
    self.clean_up
    self.push_to_dashboard(requestbase,screenshot)
    return screenshot
  end

  def set_config(key,value)
    raise "Invalid config key please use allowed values" unless CONFIG_KEYS.include? key
    hash = self.config
    hash[key] = value
    self.config = hash
    self.save
    self.publish_change
  end

  #Function is used to generate config based on the unit + global + account status
  def get_config
    global_config = {
      'pubnub_subscribe_key'=> Settings.pubnub.subscribe_key
    }

    static_config = {
      'name'=> self.name
    }

    #Manually inject the analytics from the account into the unit
    if self.admo_account and not self.admo_account.analytics.empty?
      #We hide the secret away from the clients for now.
      static_config['analytics'] = self.admo_account.analytics
      static_config['analytics'].delete(:mixpanel_api_secret)
    end

    account_config = self.admo_account.try(:config) || {}
    global_config.merge(account_config).merge(self.config).merge(static_config)
  end

  #Function cleans up older screenshots
  def clean_up
    #Delete every thing but the most recent config[:screenshot_max_keep] screenshots
    max_screenshots = self.config[:screenshot_max_keep] || 5
    #Delete the last created one while they count is more then the max
    while self.admo_screenshots.count > max_screenshots
      self.admo_screenshots.order_by('created_at asc').first.destroy
    end
  end

  def push_event(command, params ={})
    event = {
      command: command,
      params: params
    }
    PubnubPushJob.new.process(self.api_key, event.to_json)
  end


  def publish_change
    push_event('updateConfig')
  end

  def current_screenshot
    admo_screenshots.last
  end

  def online?
    return false unless self.last_checkin

    self.last_checkin > 15.minutes.ago
  end
end
