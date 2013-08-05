class AdmoUnit
  include Mongoid::Document
  include Mongoid::Timestamps

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

  has_many :admo_screenshots
  has_many :admo_images

  validates_uniqueness_of :api_key
  validates_uniqueness_of :name
  validates_presence_of :name

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
     DashboardNotifyJob.new.proccess(self.name, {:checkedinAt=>self.last_checkin,:screenshotUrl=> url, :screenshotCreatedAt=> screenshot_created_at})
  end

  def dashboard_enabled
    return (self.config.has_key? 'dashboard_enabled' and self.config['dashboard_enabled'])
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
    global_config.merge(self.config)
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
    PubnubPushJob.new.proccess(self.api_key, 'update')
  end
end
