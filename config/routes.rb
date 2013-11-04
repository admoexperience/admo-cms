AdmoCms::Application.routes.draw do
  devise_for :admins
  devise_for :users


  mount SimpleStatus::Application =>'/status/'

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  get '/media/*other', :to => Dragonfly[:images]

  scope ':account' do
    get '/dashboard/home' => 'dashboard#home', as: 'dashboard_home'
    get '/dashboard/devices' => 'dashboard#devices', as: 'dashboard_devices'
    get '/dashboard/apps' => 'dashboard#apps', as: 'dashboard_apps'
    get '/dashboard/content/:app_id(/:content_id)' => 'dashboard#content', as: 'view_content'
    post '/dashboard/content/:app_id(/:content_id)' => 'dashboard#update_content', as: 'update_content'
    post '/dashboard/content/:app_id(/:content_id(/:content_item))' => 'dashboard#update_content_item', as: 'update_content_item'
    get '/dashboard/support/' => 'dashboard#support',  as: 'support'
    post '/dashboard/support/' => 'dashboard#support', as: 'support_request'
    get '/dashboard/analytics' => 'dashboard#analytics', as: 'analytics'
  end



  get '/html/login' => 'html#login'
  get '/html/home' => 'html#home'
  get '/html/content' => 'html#content'
  get '/html/analytics' => 'html#analytics'
  get '/html/support' => 'html#support'
  get '/html/tutorial' => 'html#tutorial'
  get '/html/devices' => 'html#devices'
  get '/html/apps' => 'html#apps'

  mount RootApi => '/api/'

  root :to => "index#index"

  get '/auth/:provider/callback', to: 'sessions#create'

end
