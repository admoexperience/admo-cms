AdmoCms::Application.routes.draw do
  devise_for :admins
  devise_for :users


  mount SimpleStatus::Application =>'/status/'

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  get '/media/*other', :to => Dragonfly[:images]


  resources :app do
    resources :content
  end

  get '/dashboard/home' => 'dashboard#home'
  get '/dashboard/home/:unit_id' => 'dashboard#home'

  get '/html/login' => 'html#login'
  get '/html/home' => 'html#home'
  get '/html/content' => 'html#content'

  mount RootApi => '/api/'

  root :to => "index#index"

end
