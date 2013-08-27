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


private
  def get_units 
    if current_user.admo_account
      current_user.admo_account.admo_units
    else
      []
    end
  end
  def app_params
    puts params.inspect
    puts params.require(:app).permit(:config)
    params.require(:app).permit(:config)
  end

  def load_model
    @app = current_user.admo_account.apps.find(params[:id])
  end
end
