class Account < Grape::API
  if Rails.env.production?
    rescue_from :all
  end
  format :json
  formatter :json, Grape::Formatter::Rabl

  helpers do
    def authenticate!
      error!('Incorrect username and or password', 401) unless current_account
    end

    def current_account
      email = params[:email]
      password = params[:password]
      user = User.where(email: email).first
      if user and user.valid_password?(password)
        @account = user.admo_account
      else
        return nil
      end
    end
  end

  #Allows the requests to be made from with in JS
  before do
    header "Access-Control-Allow-Origin", "*"
  end

  desc "Account Managment API"
  resource :account do

    desc "Register Unit", :nickname => 'register_unit', :notes => <<-NOTE
    Registers a new unit, and links it to your default account.
    NOTE
    params do
      requires :email, type: String, desc: "Email address used to authenticate"
      requires :password, type: String, desc: "Password used to authenticate"
      requires :name, type: String, desc: "Units friendly name"
    end
    post :register_unit, :rabl => "unit" do
      authenticate!
      @unit = AdmoUnit.create(name: params[:name])
      @account.admo_units << @unit
      @account.save!
    end
  end
end
