AdmoCms::Application.routes.draw do
  devise_for :admins
  devise_for :users


  mount SimpleStatus::Application =>'/status/'

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  get '/media/*other', :to => Dragonfly[:images]

  scope ':account' do
    get '/dashboard/home' => 'dashboard#home', as: 'dashboard_home'
    get '/dashboard/devices' => 'dashboard#devices', as: 'dashboard_devices_post'
    post '/dashboard/devices' => 'dashboard#devices', as: 'dashboard_devices'
    get '/dashboard/templates' => 'dashboard#templates', as: 'dashboard_templates'
    post '/dashboard/add_template_to_apps' => 'dashboard#add_template_to_apps', as: 'dashboard_add_template_to_apps'
    get '/dashboard/support/' => 'dashboard#support',  as: 'support'
    post '/dashboard/support/' => 'dashboard#support', as: 'support_request'
    get '/dashboard/analytics' => 'dashboard#analytics', as: 'analytics'
    get '/dashboard/analytics/daily_interactions' => 'dashboard#analytics_daily_interactions', as: 'analytics_daily_interactions'
    get '/dashboard/analytics/by_weekday' => 'dashboard#analytics_by_weekday', as: 'analytics_by_weekday'
  end

  get '/docs/' => 'api_docs#index'


  mount RootApi => '/api/'

  root :to => "index#index"

  get '/auth/:provider/callback', to: 'sessions#create'

end
