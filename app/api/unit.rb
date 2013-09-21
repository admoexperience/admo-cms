class Unit < Grape::API
  if Rails.env.production?
    rescue_from :all
  end
  format :json
  formatter :json, Grape::Formatter::Rabl

  helpers do
    def authenticate!
      error!('Unauthorized. Invalid or expired token.', 401) unless current_user
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

  desc "My system api"
  resource :unit do

    desc "Ping", :nickname => 'ping', :notes => <<-NOTE
    Method simply returns a hash with a single key __ping => pong__ .
    This method is not authenticated and such can be used for testing access to the api
    NOTE
    get :ping do
      { :ping => "pong" }
    end


    desc "Checkin", :nickname => 'checkin',:notes => <<-NOTE
    Used to inform the CMS of the online status of the unit.
    Should be called every 5mins.
    NOTE
    get :checkin, :rabl => "checkin" do
      authenticate!
      @unit.checkin(request.base_url)
    end

    desc "Sets an config option", :nickname => 'config', :notes => <<-NOTE
    Allows updating of configuration options for AdmoUnits
    a change here will be pushed down (in close to real time) to the spesific unit provided it is online

    Configration options include the following options. Trying to set any thing else will fail.

    |Key                  |DefaultValue|Description|
    |**app**              |demo        |The current AdmoApp this unit should run|
    |**kinect_elevation** |1           |The elevation of the kinnect used to configure correct angle|
    |||

    NOTE
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

    desc "Gets configuration for the unit", :nickname => 'config'
    get :config, :rabl => "config" do
      authenticate!
      @config = @unit.get_config
    end

    desc "Pushes an event down to the unit", :nickname => 'event',:notes => <<-NOTE
    Allows sending ONE time events down to the units.

    **Note** if the unit is offline the event will be ignored!

    |Command          |Description|
    |**checkin**      |Tells the unit to checkin now, mostly can be used as a ping|
    |**screenshot**   |Tells the unit to take a screenshot and send it to the cms|
    |**updateConfig** |Tells the unit to update its config|
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
    This method can NOT be called from swagger you need to do something like

        curl --form image_file=image.jpg http://$server/$baseUrl/screenshot

    NOTE
    post "screenshot" , :rabl => "screenshot" do
      authenticate!
      raise "Screenshot is required" unless params[:screenshot]
      @screenshot = @unit.create_screenshot(request.base_url, :image=>params[:screenshot][:tempfile],:image_name=>params[:screenshot][:filename])
    end


    desc "Uploads a content", :notes=> <<-NOTE
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

      unless @unit.dropbox_session_info.empty?
        #Push to dropbox
        img.upload_to_dropbox(tempfile)
      end
      @screenshot = img
    end
  end
end
