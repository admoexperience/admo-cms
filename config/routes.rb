AdmoCms::Application.routes.draw do


  mount SimpleStatus::Application =>'/status/'

  constraints SimpleAdminAuth::Authenticate do
    mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  end

 mount RootApi => '/api/'
end
