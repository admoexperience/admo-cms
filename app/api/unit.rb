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
    get :checkin, :rabl => "unit" do
      authenticate!
      @unit.checkin
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
    end

    desc "Gets configuration for the unit", :nickname => 'config'
    get :config, :rabl => "config" do
      authenticate!
    end


    desc "Uploads a screenshot to a unit", :notes=> <<-NOTE
    This method can NOT be called from swagger you need to do something like

        curl --form image_file=image.jpg http://$server/$baseUrl/screenshot

    NOTE
    post "screenshot" , :rabl => "screenshot" do
      authenticate!
      raise "Screenshot is required" unless params[:screenshot]
      screenshot = @unit.admo_screenshots.create(:image=>params[:screenshot][:tempfile],:image_name=>params[:screenshot][:filename])
      screenshot.save!
      @unit.clean_up
      @screenshot = screenshot
    end


    desc "Uploads a content", :notes=> <<-NOTE
    This method can NOT be called from swagger you need to do something like

        curl --form image=image.jpg http://$server/$baseUrl/image

    NOTE
    post "image" , :rabl => "screenshot" do
      authenticate!
      raise "image is required" unless params[:image]

      tempfile = params[:image][:tempfile]
      file_name = params[:image][:filename]
      screenshot = @unit.admo_images.create({:image=>tempfile, :image_name=> file_name})
      screenshot.save!
      unless @unit.dropbox_session_info.empty?
        #Push to dropbox
        screenshot.upload_to_dropbox(tempfile)
      end
      @screenshot = screenshot
    end
  end
end
