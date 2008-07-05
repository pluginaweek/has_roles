# A role defines a group of users in the system who are able to access a
# collection of features in the application.  Examples of roles could be
# 'Administrator', 'Developer', or 'Guest'.
class Role < ActiveRecord::Base
  acts_as_enumeration
  
  # The list of permissions that this role has access to
  attr_accessor :permissions
  
  has_many  :assignments,
              :class_name => 'RoleAssignment'
  
  def initialize(attributes = nil) #:nodoc:
    super
    @authorizations ||= {}
    @permissions = []
  end
  
  # Is this role authorized for the given url?  The url can be any one of the
  # following formats:
  # * +string+ - A relative or absolute path in the application
  # * +hash+ - A hash include the controller/action attributes
  # 
  # Using this information, the controller and action can be determined.
  # Authorization is based on whether the role has a permission that either
  # directly matches the path or represents a parent path (i.e. using the
  # controller/class hierarchy)
  def authorized_for?(options = '')
    path = Permission.recognize_path(options)
    
    if (authorized = @authorizations[path]).nil?
      controller, action = path
      controllers = "#{controller.camelize}Controller".constantize.ancestors.select {|c| c < ActionController::Base}.map(&:controller_path)
      authorized = @authorizations[path] = permissions.any? {|permission| controllers.include?(permission.controller) && (!permission.action? || permission.action == action)}
    end
    
    authorized
  end
  
  create :id => 1, :name => 'admin', :permissions => [
    Permission['application/']
  ]
end
