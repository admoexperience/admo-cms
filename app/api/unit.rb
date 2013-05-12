class Unit < Grape::API
  format :json
  formatter :json, Grape::Formatter::Rabl

  helpers do
    def authenticate!
      error!('Unauthorized. Invalid or expired token.', 401) unless current_user
    end

    def current_user
      # find token. Check if valid.
      user_token = params[:api_key]
      token = AdmoUnit.where(:api_key => user_token).first
      token
    end
  end

  desc "My system api"
  resource :unit do
    desc "Ping", :nickname => 'ping'
    get :ping do
      { :ping => "pong", :ding => 'david' }
    end


    desc "Checkin" :nickname => 'checkin'
    get :checkin, :rabl => "unit" do
      authenticate!
      Rails.logger.info current_user
      @unit = current_user
      @unit.checkin
    end


  end
end
