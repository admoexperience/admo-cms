require 'grape-swagger'

class RootApi < Grape::API
  format :json
 # prefix 'api'
  version 'v1', using: :path
  mount Unit

  add_swagger_documentation({
    :base_path_suffix=> '/api',
    :api_version=>'v1',
    :hide_documentation_path=>true,
    :markdown=>true
    }
  )
end
# https://github.com/drapergem/draper/wiki/Using-Rails-Path-Helpers-in-Draper-Decorators-with-Grape
# https://github.com/nesquena/rabl/wiki/Using-Rabl-with-Grape

 module Grape
  class Endpoint
    include Rails.application.routes.url_helpers
    default_url_options[:host] = ::Rails.application.routes.default_url_options[:host]
  end
end

module Rabl
  class Engine
    # Access Application Helpers
    include ActionView::Helpers::ApplicationHelper
    include Rails.application.routes.url_helpers
    default_url_options[:host] = ::Rails.application.routes.default_url_options[:host]
  end
end
