class DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_account


  def home

  end

  def apps

  end

  def devices
    @units = get_units
  end

  def content
    @app = get_account.apps.find(params[:app_id])
    @current_content = params[:content_id]
  end

  def update_content
    @app = get_account.apps.find(params[:app_id])
    @current_content = params[:content_id]
    content = params[:content]
    config = @app.config
    config[@current_content]= content
    @app.config = config
    @app.save!
    #should always publish on content saving.
    @app.publish_change
    redirect_to view_content_path(@app,@current_content)
  end

  def update_content_item
    @app = get_account.apps.find(params[:app_id])
    @cont = @app.contents.find(params[:content_item])
    @cont.value = params[:upload]
    @cont.last_edited_at = Time.now
    @cont.save!
    respond_to do |format|
      format.html {
        render :json => [@cont.to_jq_upload].to_json,
        :content_type => 'text/html',
        :layout => false
      }
      format.json {
        render :json => [@cont.to_jq_upload].to_json
      }
    end
  end

  def support
    if request.post?
      email = {
        :user_email => current_user.email,
        :extra_info =>{
          :account => @account.name,
          :user_agent=> request.user_agent
        }.to_yaml
      }
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
    analytics = get_account.analytics
    unless analytics
      @analytics_not_present = true
      return
    end

    config = {api_key: analytics[:mixpanel_api_key], api_secret: analytics[:mixpanel_api_secret]}

    api = MixpanelApi.new(config)
    @total_interactions = cache("total_interactions") do
      api.total_interactions
    end
    @daily_avg_interactions = @total_interactions / 30

    daily_interactions_tmp = cache("daily_interactions") do
      api.daily_interactions
    end

    daily_interactions_sorted = daily_interactions_tmp.sort_by {|k,v| k }
    ########
    daily = {}
    @daily_interactions = daily_interactions_sorted.map do |key,value|
      d = DateTime.parse(key)
      tool_tip = d.strftime("%a %d %b")
      {label: tool_tip.chars.first, tooltip: tool_tip, value: value, bold: tool_tip.start_with?("Sun")}
    end

    ########
    daily_interactions_sorted.each do |key, value|
      d = DateTime.parse(key)
      day = d.strftime("%A")
      daily[day] = 0 unless daily.has_key? day
      daily[day] += value.to_i
    end

    @days_of_week_interactions = daily.sort_by {|k,v| DateTime.parse(k).strftime("%u")}.map do |key,value|
      {label: key[0..2], tooltip: key, value: value, bold: key.start_with?("Sun")}
    end

    @busiest_day_of_week =  daily.sort_by{|k,v| v}.last[0]


    interactions_by_host  = cache("interactions_by_host") do
      api.total_interactions_by_host
    end

    @interactions_by_host = interactions_by_host.sort_by{|k,v| v}.reverse.map do |key, value|
      {host_name: key, total: value }
    end



    @last_updated = cache('laste_updated') do
      Time.now.strftime("%H:%m")
    end
  end

private
  def cache(key, &block)
     Rails.cache.fetch(key+'_'+get_account.id+'_'+current_user.id, :expires_in => 5.minute) do
        block.call
     end
  end

  def support_params
    params.require(:support).permit([:subject,:message])
  end

  def get_account
    @account = current_user.accounts.find(params[:account])
  end

  def get_units
    if get_account
      get_account.admo_units.order_by(:name => :desc)
    else
      []
    end
  end
end
