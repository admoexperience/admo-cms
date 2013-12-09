class Unit < Grape::API
  if Rails.env.production?
    rescue_from :all
  end
  format :json
  formatter :json, Grape::Formatter::Rabl

  helpers do
    def authenticate!
      error!('Unauthorized. Invalid or expired ApiKey.', 401) unless current_user
    end

    def current_user
      api_key = params[:api_key] || headers['Api-Key']
      @unit = AdmoUnit.where(:api_key => api_key).first
      @unit
    end
  end

  #Allows the requests to be made from with in JS
  before do
    header "Access-Control-Allow-Origin", "*"
  end

  desc "Unit API to control and manage a single unit"
  resource :unit do

    desc "Ping", :nickname => 'ping', :notes => <<-NOTE
    Method simply returns a hash with a single key __ping => pong__ .
    This method is __not authenticated__ and such can be used for testing communication access to the api
    NOTE
    get :ping do
      { :ping => "pong" }
    end


    desc "Checkin", :nickname => 'checkin',:notes => <<-NOTE
    Used to inform the CMS of the online status of the unit.
    Should be called every +-5mins.
    NOTE
    get :checkin, :rabl => "checkin" do
      authenticate!
      @unit.checkin
    end


    CONFIG_HELP_TABLE = <<-NOTE
    Configration options include the following options.

|Key                         |DefaultValue|Description|
|----------------------------|------------|-----------|
|**environment**             |production                  |Environment the unit should run in [production,development]|
|**web_ui_server**           |https://localhost:5001      |Which url to launch at start up, ie where the html5 appliation is hosted|
|**web_server_base_path**    |`%APP_DATA%/Admo/webserver/`|The folder on disk where the webserver content is actually hosted from. Used for watching for file changes|
|**pod_file**                |na                          |File path to ziped html5 application, which will be extracted into `web_server_base_path/current`. file can either relative path to `%APP_DATA%/Admo/Pods/` or an absolute path to any where on disk|
|**kinect_elevation**        | -9                         |The elevation of the kinnect used to configure correct angle|
|**pubnub_subscribe_key**    |Server configed default     |Subscribe key used to connect to pubnub. The publish/subscribe channel. Each unit runs on a unique channel|
|**screenshot_interval**     |1800                        |Number of seconds between taking a screenshot and uploading it to the CMS       |
|**calibration_active**      |false                       |If the unit should re-set its FOV calibration settings|
|**name**                    |PC hostname                 |Hostname of the pc|
|**transform_smoothing_type**|avatar                      |Application type [avatar,cursor]|
|**fov_crop_top**            |0                           |Used to line up HD-webcam and kinect FOV so they are in sync|
|**fov_crop_left**           |0                           |Used to line up HD-webcam and kinect FOV so they are in sync|
|**fov_crop_width**          |0                           |Used to line up HD-webcam and kinect FOV so they are in sync|
|**silhouette_enabled**      |true                        |If the service should send through silhouette info to html5 app|
|**dropbox_img_path**        |na                          |When uploading content to dropbox, where to put it|
|**facebook_auth_token**     |na                          |Facebook Auth Token, for api requests, see [Facebook link](https://developers.facebook.com/docs/facebook-login/access-tokens/) |
|**facebook_album_id**       |me                          |Where to push the facebook image default is to the wall|
|**dashboard_enabled**       |false                       |If this unit should be monitored via the dashboard|
|||
    NOTE




    desc "Updates a config option", :nickname => 'config', :notes =>
    "Allows updating of configuration options for an unit.\n"+
    "the change will be pushed down via publish/subscribe to the specific unit provided it is online."+
    CONFIG_HELP_TABLE
     params do
        requires :key, type: String, desc: "Config Key"
        requires :value, type: String, desc: "Config Value"
      end
    put :config, :rabl => "config" do
      authenticate!
      key = params[:key]
      value = params[:value]
      #TODO: Move logic into model
      # error!("Invalid config key please use allowed values") unless AdmoUnit::CONFIG_KEYS.include? key
      @unit.set_config(key,value)
      @config = @unit.get_config
    end

    desc "Gets configuration for the unit", :nickname => 'config', :notes=>
    "Retrives the current configuration of this unit. See PUT `config`"+
    CONFIG_HELP_TABLE
    get :config, :rabl => "config" do
      authenticate!
      @config = @unit.get_config
    end

    desc "Pushes an event down to the unit", :nickname => 'event',:notes => <<-NOTE
    Allows sending one time events down to the units via the publish/subscribe channel

    **Note** if the unit is offline the event will be ignored!

    |Command          |Description|
    |**checkin**      |Checkin now, mostly can be used as a ping|
    |**screenshot**   |Take a screenshot and send it to the cms|
    |**updateConfig** |Config has been updated go and fetch a new version|
    |**calibrate**    |Calibrate the unit|
    |||
    NOTE
    params do
      requires :command, type: String, desc: "Command you want to send"
    end
    put :event, :rabl => "event" do
      authenticate!
      @unit.push_event(params[:command])
    end


    desc "Uploads a screenshot to a unit", :notes=> <<-NOTE
    Uploads and links a screenshot.
    This method can NOT be called from swagger you need to do something like

        curl --form image_file=image.jpg http://$server/$baseUrl/screenshot

    NOTE
    post "screenshot" , :rabl => "screenshot" do
      authenticate!
      raise "Screenshot is required" unless params[:screenshot]
      @screenshot = @unit.create_screenshot(:image=>params[:screenshot][:tempfile],:image_name=>params[:screenshot][:filename])
    end


    desc "Uploads a an image", :notes=> <<-NOTE
    Uploads and links a image to a unit. Useful for taking pictures.


    This method can NOT be called from swagger you need to do something like

        curl --form image=@image.jpg --form tags=testing,mytag,newtag  http://$server/$baseUrl/image

    NOTE
    post "image" , :rabl => "screenshot" do
      authenticate!
      raise "image is required" unless params[:image]

      tempfile = params[:image][:tempfile]
      file_name = params[:image][:filename]
      tags = params[:tags] || ''

      img = @unit.admo_images.create({:image=>tempfile, :image_name=> file_name, :tags=> tags })
      img.save!

      dbsession = @unit.admo_account.dropbox_session_info
      unless dbsession.blank?
        #Push to dropbox
        img.upload_to_dropbox(tempfile,dbsession)
      end

      auth_token = @unit.get_config['facebook_auth_token']
      fb_album_id = @unit.get_config['facebook_album_id']
      unless auth_token.blank? or fb_album_id.blank?
        img.upload_to_facebook(auth_token,fb_album_id)
      end

      @screenshot = img
    end


    desc "Lists apps that should be assosiated with this unit", :notes=> <<-NOTE

    NOTE
    get "apps" , :rabl => "apps" do
      authenticate!
      @apps = @unit.admo_account.apps
    end

    desc "Sets the current running version of the client software of this unit", :notes=> <<-NOTE
    Should be called at application start up.
    NOTE
    params do
      requires :number, type: String, desc: "Softwares Version number formate (1.1.1.1+)"
    end
    post "client_version" , :rabl => "client_version" do
      authenticate!
      @client_version  = @unit.update_client_version(params[:number])
    end
  end
end
