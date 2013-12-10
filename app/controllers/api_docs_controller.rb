class ApiDocsController < ApplicationController
  layout false
  def index
    @account = current_user.admo_account if current_user
  end
end
