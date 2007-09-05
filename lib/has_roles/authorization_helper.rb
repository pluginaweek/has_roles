module PluginAWeek #:nodoc:
  module Has #:nodoc:
    module Roles
      # Provides helper methods for determining whether users are authorized
      # for a given url.
      # 
      # In order to determine who the current user is, the helper methods
      # assume that a +current_user+ helper has been defined.  If this method
      # is not already defined, it will assume that the current user is stored
      # in the session as +session['user']+.  If your application implements
      # this differently, you can override it like so:
      # 
      #   module ApplicationHelper
      #     def current_user
      #       session['user_id'] ? User.find(session['user_id']) : nil
      #     end
      #   end
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
        
        # Check if the user is authorized for the url specified by the given options.
        # See +Controller#recognize_path+ for a description of the possible
        # options that can be passed in.
        def authorized_for?(options = {})
          current_user && current_user.authorized_for?(options)
        end
        
        # Only link to the url if the user is authorized to access it.  In
        # addition to the options normally available in +link_to+, the following
        # options can be specified:
        # * +show_text+ - If set to true, will only display the text if the user is not authorized for the link. (Default is +false+).
        def link_to_if_authorized(name, options = {}, html_options = {}, *parameters_for_method_reference, &block)
          text_on_no_authorization = html_options.delete(:show_text) ? name : ''
          
          if authorized_for?(options)
            link_to name, options, html_options, *parameters_for_method_reference, &block
          else
            text_on_no_authorization
          end
        end
      end
    end
  end
end

ActionController::Base.class_eval do
  helper PluginAWeek::Has::Roles::AuthorizationHelper
end
