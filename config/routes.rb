AdmoCms::Application.routes.draw do
  devise_for :admins
  devise_for :users


  mount SimpleStatus::Application =>'/status/'

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  get '/media/*other', :to => Dragonfly[:images]


  resources :app do
    resources :content
  end

  get '/dashboard/home(/:unit_id)' => 'dashboard#home'
  get '/dashboard/content/:app_id(/:content_id)' => 'dashboard#content', as: 'view_content'
  post '/dashboard/content/:app_id(/:content_id)' => 'dashboard#content', as: 'update_content'
  get '/dashboard/support/' => 'dashboard#support'

  get '/html/login' => 'html#login'
  get '/html/home' => 'html#home'
  get '/html/content' => 'html#content'
  get '/html/analytics' => 'html#analytics'
  get '/html/support' => 'html#support'

  mount RootApi => '/api/'

  root :to => "index#index"

end
