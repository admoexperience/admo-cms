require 'grape-swagger'

  class RootApi < Grape::API
    format :json
    #version 'v1', using: :path
    mount Unit
    add_swagger_documentation({
      :api_version=>'v1',
      :hide_documentation_path=>true, 
      :markdown=>true
      }
    )
  end