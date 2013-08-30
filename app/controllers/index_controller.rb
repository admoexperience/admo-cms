class IndexController < ApplicationController
  before_filter :authenticate_user!
  def index
    redirect_to dashboard_home_path
  end
end
