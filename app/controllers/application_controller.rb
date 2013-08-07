class ApplicationController < ActionController::Base
  protect_from_forgery

protected
  def current_user
    request.session[:admin_user]
  end
end
