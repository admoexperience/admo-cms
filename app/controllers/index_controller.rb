class IndexController < ApplicationController
  before_filter :authenticate_user!
  def index
    redirect_to current_user.home_path
  end
end
