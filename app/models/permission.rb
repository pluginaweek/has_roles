# A permission defines access to a single part of an application, restricted by
# both controller and action specifications.
# 
# Permissions can be application-, controller-, or action-specific.  Permissions
# using the +application+ controller are global.  Permissions without any +action+
# specified are controller-specific.  Permissions with both +controller+ and
# +action+ specified are action-specific.
class Permission < ActiveRecord::Base
  acts_as_enumeration :path
  
  column :controller, :string
  column :action, :string
  
  validates_presence_of   :controller
  validates_length_of     :action,
                            :minimum => 1,
                            :allow_nil => true
  
  class << self
   # Is there a permission that exists which restricts the given url?
    def restricts?(options = '')
      controller, action = recognize_path(options)
      permission = find_by_path("#{controller}/") || find_by_path("#{controller}/#{action}")
      !permission.nil?
    end
    
    # Parses the controller path and action from the given options
    def recognize_path(options = '')
      options = ActionController::Routing::Routes.recognize_path(URI.parse(options).path) if options.is_a?(String)
      return options[:controller], options[:action] ? options[:action].to_s : 'index'
    end
  end
  
  def initialize(attributes = {}) #:nodoc:
    super
    self.path = "#{controller}/#{action}"
  end
  
  create :id => 1, :controller => 'application'
end
