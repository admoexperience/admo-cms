AdmoCms::Application.routes.draw do


  mount SimpleStatus::Application =>'/status/'

  constraints SimpleAdminAuth::Authenticate do
    mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

    get '/m', controller: "mobile_site", action: 'units'
    get '/m/apps', controller: "mobile_site", action: 'apps'
  end

  match '/media/*other', :to => Dragonfly[:images]

  mount RootApi => '/api/'

  root :to => redirect('/docs/')
end
