class Unit < Grape::API
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

  desc "My system api"
  resource :unit do
    desc "Ping", :nickname => 'ping'
    get :ping do
      { :ping => "pong" }
    end


    desc "Checkin", :nickname => 'checkin'
    get :checkin, :rabl => "unit" do
      authenticate!
      @unit.checkin
    end

    desc "Set App", :nickname => 'app'
     params do
        requires :app, type: String, desc: "App to set"
      end
    put :app, :rabl => "unit" do
      authenticate!
      @unit.set_app(params[:app])
    end

  end
end
