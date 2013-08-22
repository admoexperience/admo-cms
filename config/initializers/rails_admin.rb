# RailsAdmin config file. Generated on May 10, 2013 11:11
# See github.com/sferik/rails_admin for more informations


require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdminPublish
end

module RailsAdmin
  module Config
    module Actions
      class Publish < RailsAdmin::Config::Actions::Base

       RailsAdmin::Config::Actions.register(self)
       register_instance_option :visible? do
          bindings[:object].respond_to? :publish_change
        end

        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          'icon-fire'
        end

        register_instance_option :controller do
         Proc.new do
           name = @object.try(:name) || @object.class.to_s
           @object.publish_change
           flash[:notice] = "You have published #{name}."
           redirect_to back_or_index
         end
       end
     end
    end
  end
end


RailsAdmin.config do |config|


config.actions do
   # root actions
    dashboard                     # mandatory
    # collection actions
    index                         # mandatory
    new
    export
    history_index
    bulk_delete
    # member actions
    show
    edit
    delete
    history_show
    show_in_app
    publish
end

  ################  Global configuration  ################

  # Set the admin name here (optional second array element will appear in red). For example:
  #config.main_app_name = ['Admo Cms', 'Admin']
  # or for a more dynamic name:
  config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # RailsAdmin may need a way to know who the current user is]
  config.current_user_method { current_admin } # auto-generated


  # If you want to track changes on your models:
  # config.audit_with :history, 'User'

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, 'User'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  # config.default_items_per_page = 20

  # Exclude specific models (keep the others):
  # config.excluded_models = ['AdmoUnit']

  # Include specific models (exclude the others):
  # config.included_models = ['AdmoUnit']

  # Label methods for model instances:
  # config.label_methods << :description # Default is [:name, :title]

  config.model 'AdmoUnit' do
    edit do
      configure :admo_screenshots do
        hide
      end
      configure :admo_images do
        hide
      end
    end
  end
end


