AdmoCms::Application.routes.draw do


  mount SimpleStatus::Application =>'/status/'

  constraints SimpleAdminAuth::Authenticate do
    mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  end

  match '/media/*other', :to => Dragonfly[:images]

  mount RootApi => '/api/'

  root :to => redirect('/docs/')
end
