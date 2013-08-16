class AppController < ApplicationController
  before_action :load_model, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!


  def index
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
   @template = @app.compiled_template
  end

  def edit

  end


private
  def app_params
    puts params.inspect
    puts params.require(:app).permit(:config)
    params.require(:app).permit(:config)
  end

  def load_model
    @app = current_user.admo_account.apps.find(params[:id])
  end
end
