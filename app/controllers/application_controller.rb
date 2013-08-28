class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :reload_rails_admin if :rails_admin_path?

  helper_method :users_app

protected

  def users_app
    current_user.admo_account.apps.first
  end


private
  def reload_rails_admin
    models = %W(AdmoUnit AdmoScreenshot AdmoImage AdmoAccount Content App User)
    models.each do |m|
      RailsAdmin::Config.reset_model(m)
    end
    RailsAdmin::Config::Actions.reset

    load("#{Rails.root}/config/initializers/rails_admin.rb")
  end

  def rails_admin_path?
    controller_path =~ /admin/ && Rails.env.development?
  end
end
