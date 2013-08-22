AdmoCms::Application.routes.draw do
  devise_for :admins
  devise_for :users


  mount SimpleStatus::Application =>'/status/'

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  get '/media/*other', :to => Dragonfly[:images]


 resources :app do
    resources :content
 end

 mount RootApi => '/api/'

 root :to => "index#index"

end
