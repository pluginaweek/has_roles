# A role defines a group of users in the system who are able to access a
# collection of features in the application.  Examples of roles could be
# 'Administrator', 'Developer', or 'Guest'.
# 
# == Adding permissions
# 
# The features that a role has access to is dependent on the permissions that
# have been assigned to the role.
# 
# To add permissions to an existing role, such as the administrator role
# pre-defined in this model:
# 
#   Role[:administrator].permissions << 'admin/stats/'
# 
# To assigns permissions to a new role:
# 
#   Role.create :id => 2, :name => 'developer', :permissions => %w(
#     comments/create
#     admin/stats/
#   )
# 
# Notice that permissions are in the form of the path defined by the
# controller/action.
class Role < ActiveRecord::Base
  acts_as_enumeration
  
  # The list of permissions that this role has access to
  attr_accessor :permissions
  
  has_many  :assignments,
              :class_name => 'RoleAssignment'
  
  def initialize(attributes = nil) #:nodoc:
    super
    
    @permissions ||= []
    @authorizations = {}
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
      
      # Include parent controllers for inheritance support
      controllers = "#{controller.camelize}Controller".constantize.ancestors.select {|c| c < ActionController::Base}.map(&:controller_path)
      
      authorized = @authorizations[path] = permissions.any? do |permission|
        permission = Permission[permission] unless permission.is_a?(Permission)
        controllers.include?(permission.controller) && (!permission.action? || permission.action == action)
      end
    end
    
    authorized
  end
  
  create :id => 1, :name => 'admin', :permissions => %w(application/)
end
