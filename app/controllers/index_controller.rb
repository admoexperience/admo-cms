class IndexController < ApplicationController
  before_filter :authenticate_user!
  def index
    redirect_to dashboard_home_path(current_user.primary_account)
  end
end
