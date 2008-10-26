# A permission defines access to a single part of an application, restricted by
# both controller and action specifications.
# 
# Permissions can be application-, controller-, or action-specific.  Permissions
# using the +application+ controller are global.  Permissions without any +action+
# specified are controller-specific.  Permissions with both +controller+ and
# +action+ specified are action-specific.
# 
# == Examples
# 
#   create :id => 1, :controller => 'application'               # Access to the whole application
#   create :id => 2, :controller => 'users'                     # Access to the Users controller (any action)
#   create :id => 3, :controller => 'users', :action => 'index' # Access to the Users controller and index action
class Permission < ActiveRecord::Base
  acts_as_enumeration :path
  
  column :controller, :string
  column :action, :string
  
  validates_presence_of   :controller
  validates_length_of     :action,
                            :minimum => 1,
                            :allow_nil => true
  
  class << self
    # Is there a permission that exists which restricts the given url?  If there
    # is no permission that restricts the path, then anyone should be allowed
    # access to it
    def restricts?(options = '')
      controller, action = recognize_path(options)
      
      # See if a permission exists for either the controller or controller/action
      # combination.  If it doesn't, then the path isn't restricted
      permission = find_by_path("#{controller}/") || find_by_path("#{controller}/#{action}")
      !permission.nil?
    end
    
    # Parses the controller path and action from the given options.  Options may
    # be in any one of the following formats:
    # * +string+ - A relative or absolute path in the application
    # * +hash+ - A hash include the controller/action attributes
    def recognize_path(options = '')
      # Grab the actual url options if the path is specified
      options = ActionController::Routing::Routes.recognize_path(URI.parse(options).path) if options.is_a?(String)
      
      # Only return the controller/action of the url options
      return options[:controller], options[:action] ? options[:action].to_s : 'index'
    end
  end
  
  def initialize(attributes = nil) #:nodoc:
    super
    self.path = "#{controller}/#{action}"
  end
  
  create :id => 1, :controller => 'application'
end
