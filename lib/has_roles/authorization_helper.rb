module PluginAWeek #:nodoc:
  module Has #:nodoc:
    module Roles
      # 
      module AuthorizationHelper
        def self.included(base) #:nodoc:
          unless base.instance_methods.include?('current_user')
            base.class_eval do
              def current_user
                session['user']
              end
            end
          end
        end
        
        # Only link to the url if the user is authorized to access it
        def link_to_if_authorized(name, options = {}, html_options = {}, *parameters_for_method_reference, &block)
          text_on_no_authorization = html_options.delete(:show_text) ? name : ''
          
          if authorized_for?(options)
            link_to name, options, html_options, *parameters_for_method_reference, &block
          else
            text_on_no_authorization
          end
        end
        
        # Check if the user is authorized for the url specified by the given options
        def authorized_for?(options = {})
          current_user && current_user.authorized_for?(options)
        end
      end
    end
  end
end
