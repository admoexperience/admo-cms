class ContentController < ApplicationController
  before_action :load_model, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  def index
  end

  def show
  end

  def edit

  end

 def update
    if @content.update_attributes(content_params)
      @content.last_edited_at = Time.now
      @content.save!
      @content.app.publish_change
      flash[:notice] = 'Content was successfully updated.'
      redirect_to :action=> :show
    else
      render action: "edit"
    end
 end


private
  def content_params
    params.require(:content).permit(:value)
  end

  def load_model
    @app = current_user.admo_account.apps.find(params[:app_id])
    @content = @app.contents.find(params[:id])
  end
end
