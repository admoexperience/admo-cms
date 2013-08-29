class DashboardController < ApplicationController
  before_filter :authenticate_user!


  def home
    @units = get_units
    @current_unit = @units.first
    if params[:unit_id]
      @current_unit = AdmoUnit.find(params[:unit_id])
    end
  end

  def content
    @app = get_account.apps.find(params[:app_id])
    @current_content = params[:content_id]
  end

  def update_content

  end

  def support
    if request.post?
      email = {:user_email=> current_user.email}
      SupportMailer.help(support_params.merge(email)).deliver
    end
  end

  def update
    #TODO: Figure out rails4 mass assignment provention,
    #but this is only for the hash it is should be ok
    @app.config =  params.require(:app)[:config]
    if  @app.save
     #@app.publish_change
      flash[:notice] = 'App was successfully updated.'
      redirect_to :action=> :show
    else
      render action: "edit"
    end
  end

  def show
   @template = @app.config_as_json
  end

  def edit

  end

  def analytics

  end

private
  def support_params
    params.require(:support).permit([:subject,:message])
  end

  def get_account
    current_user.admo_account
  end

  def get_units
    if current_user.admo_account
      current_user.admo_account.admo_units
    else
      []
    end
  end
end
