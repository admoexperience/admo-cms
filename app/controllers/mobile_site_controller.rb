class MobileSiteController < ApplicationController
  
  def units
    @units = AdmoUnit.all
  end

  def apps
    @apps = ['demo','trailers','zerogravity','adscandemo','trailerdemo','flightcentre','traveldemo']
    
    @unit = AdmoUnit.find(params[:unit])
    redirect_to :units unless @unit

    if params[:app]
      raise "app not in allowed list" unless @apps.include? params[:app]
      @unit.set_config('app',params[:app])
      flash[:info] = "App set to #{params[:app]}"
      redirect_to :action=>:units
    end
  end
end
