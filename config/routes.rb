AdmoCms::Application.routes.draw do
  devise_for :users
  mount SimpleStatus::Application =>'/status/'

  constraints SimpleAdminAuth::Authenticate do
    mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  end

  get '/media/*other', :to => Dragonfly[:images]

  mount RootApi => '/api/'

  root :to => redirect('/docs/')
end
