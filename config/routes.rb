AdmoCms::Application.routes.draw do
  devise_for :admins
  devise_for :users


  mount SimpleStatus::Application =>'/status/'

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  get '/media/*other', :to => Dragonfly[:images]


  resources :app do
    resources :content
  end

  get '/dashboard/home(/:unit_id)' => 'dashboard#home', as: 'dashboard_home'
  get '/dashboard/content/:app_id(/:content_id)' => 'dashboard#content', as: 'view_content'
  post '/dashboard/content/:app_id(/:content_id)' => 'dashboard#update_content', as: 'update_content'
  post '/dashboard/content/:app_id(/:content_id(/:content_item))' => 'dashboard#update_content_item', as: 'update_content_item'
  get '/dashboard/support/' => 'dashboard#support',  as: 'support'
  post '/dashboard/support/' => 'dashboard#support', as: 'support_request'

  get '/dashboard/analytics' => 'dashboard#analytics', as: 'analytics'

  get '/html/login' => 'html#login'
  get '/html/home' => 'html#home'
  get '/html/content' => 'html#content'
  get '/html/analytics' => 'html#analytics'
  get '/html/support' => 'html#support'

  mount RootApi => '/api/'

  root :to => "index#index"

end
