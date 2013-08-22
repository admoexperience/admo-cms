class IndexController < ApplicationController
  before_filter :authenticate_user!
  def index
    redirect_to app_index_path
  end
end
