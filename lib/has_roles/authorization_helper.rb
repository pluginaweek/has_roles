module PluginAWeek #:nodoc:
  module HasRoles
    # Provides helper methods for determining whether users are authorized
    # for a given url.
    # 
    # In order to determine who the current user is, the helper methods
    # assume that a +current_user+ helper has been defined.  An example of an
    # implementation of +current_user+ could be:
    # 
    #   module ApplicationHelper
    #     def current_user
    #       session['user_id'] ? User.find(session['user_id']) : nil
    #     end
    #   end
    module AuthorizationHelper
      # Checks if the current user is authorized for the url specified by the
      # given options. See <tt>PluginAWeek::HasRoles::InstanceMethods#authorized_for?</tt>
      # for a description of the possible options that can be passed in.
      # 
      # If there is no current user, then the authorization will fail.
      # 
      # == Examples
      # 
      #   authorized_for?(:controller => 'admin/messages')
      #   authorized_for?(:controller => 'admin/messages', :action => 'destroy')
      #   authorized_for?('admin/messages')
      #   authorized_for?('http://localhost:3000/admin/messages')
      def authorized_for?(options = {})
        current_user && current_user.authorized_for?(options)
      end
      
      # Only link to the url if the current user is authorized to access it.  In
      # addition to the options normally available in +link_to+, the following
      # options can be specified:
      # * +show_text+ - If set to true, will only display the text if the user is not authorized for the link. (Default is +false+).
      def link_to_if_authorized(name, options = {}, html_options = {}, &block)
        text_on_no_authorization = html_options.delete(:show_text) ? name : ''
        
        if authorized_for?(options)
          link_to(name, options, html_options, &block)
        else
          text_on_no_authorization
        end
      end
    end
  end
end

ActionController::Base.class_eval do
  helper PluginAWeek::HasRoles::AuthorizationHelper
end
