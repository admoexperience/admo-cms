require 'grape-swagger'

class RootApi < Grape::API
  format :json
 # prefix 'api'
  version 'v1', using: :path
  mount Unit
  mount Account

  add_swagger_documentation({
    :base_path => lambda { |request| "#{request.base_url}/api" },
    :api_version=>'v1',
    :hide_documentation_path=>true,
    :markdown=>true
    }
  )
end
