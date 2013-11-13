class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :reload_rails_admin if :rails_admin_path?

  helper_method :users_app

  before_filter :configure_permitted_parameters, if: :devise_controller?

  before_bugsnag_notify :add_user_info_to_bugsnag

protected

  def users_app
    current_user.admo_account.apps.first
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up)  do |u|
      u.permit(:first_name, :last_name, :company_name, :email, :password)
    end
  end

private
  def reload_rails_admin
    models = %W(AdmoUnit AdmoScreenshot AdmoImage AdmoAccount Content App User Template)
    models.each do |m|
      RailsAdmin::Config.reset_model(m)
    end
    RailsAdmin::Config::Actions.reset

    load("#{Rails.root}/config/initializers/rails_admin.rb")
  end

  def rails_admin_path?
    controller_path =~ /admin/ && Rails.env.development?
  end

  def add_user_info_to_bugsnag(bug)
    return unless current_user
    # Add some app-specific data which will be displayed on a custom
    # "User Info" tab on each error page on bugsnag.com
    bug.add_tab(:user_info, {
      email: current_user.email,
      account: current_user.admo_account.name,
    })
  end
end
