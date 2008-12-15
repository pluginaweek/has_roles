module HasRoles
  # Provides helper methods for determining whether users are authorized
  # for a given url.
  module AuthorizationHelper
    def self.included(base) #:nodoc:
      base.class_eval do
        helper_method :authorized?
        helper_method :authorized_for?
      end
    end
    
    protected
      # Is the user authorized for the current url?  If there is no current
      # user, then this will return false.  If there *is* a current user, then
      # this will return true/false depending on whether the user is assigned
      # a role that has permission to access the current request url.
      def authorized?
        authorized_for?(request.request_uri)
      end
      
      # Checks if the current user is authorized for the url specified by the
      # given options. See <tt>HasRoles::InstanceMethods#authorized_for?</tt>
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
      
      # Ensures that the user is authorized for the current url.  If not
      # authorized, then a 401 "Unauthorized" response will be sent back.
      # 
      # This is useful for defining filters on resources that are protected
      # based on the role of the current user.  For example,
      # 
      #   class PostsController < ApplicationController
      #     before_filter :authorization_required, :only => [:destroy]
      #     ...
      #   end
      # 
      # See #authorization_denied for the response given and how to provide
      # a custom implementation for responding to unauthorized requests.
      def authorization_required
        authorized? || authorization_denied
      end
      
      # Renders an "unauthorized request" response to the user.  By default,
      # this is a simple HEAD response with the status code set to 401.  This
      # method should be overridden to provide a custom implementation for
      # authorization denials, such as redirecting to a particular page:
      # 
      #   class ApplicationController < ActionController::Base
      #     ...
      #     protected
      #       def authorization_denied
      #         flash[:notice] = 'Unauthorized'
      #         redirect_to root_url
      #       end
      #   end
      def authorization_denied
        head :unauthorized
      end
  end
end

ActionController::Base.class_eval do
  include HasRoles::AuthorizationHelper
end
