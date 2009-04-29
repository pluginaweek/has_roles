module HasRoles
  # Provides helper methods for conditionally making links depending on
  # whether the current user is authorized to access the url being linked to.
  # 
  # In order to determine who the "current user" is, the helper methods
  # assume that a +current_user+ helper has been defined.  An example of an
  # implementation of +current_user+ could be:
  # 
  #   class ApplicationController < ActionController::Base
  #     ...
  #     
  #     protected
  #       def current_user
  #         @current_user ||= session[:user_id] ? User.find_by_id(session[:user_id]) : nil
  #       end
  #       helper_method :current_user
  #   end
  module UrlHelper
    # Only link to the url if the current user is authorized to access it.  In
    # addition to the options normally available in +link_to+, the following
    # options can be specified:
    # * +show_text+ - If set to true, will only display the text if the user
    #   is not authorized for the link. (Default is +false+).
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

ActionController::Base.class_eval do
  helper HasRoles::UrlHelper
end
