# A role defines a group of users in the system who are able to access a
# collection of features in the application.
# 
# == Examples
# 
#   Role.bootstrap(
#     {:id => 1, :name => 'administrator'},
#     {:id => 2, :name => 'developer'},
#     {:id => 3, :name => 'guest'}
#   )
class Role < ActiveRecord::Base
  enumerate_by :name
  
  has_many :assigned_permissions, :class_name => 'RolePermission'
  has_many :permissions, :through => :assigned_permissions
  has_many :assignments, :class_name => 'RoleAssignment'
  
  # Is this role authorized for the given url?  The url can be any one of the
  # following formats:
  # * +string+ - A relative or absolute path in the application
  # * +hash+ - A hash include the controller/action attributes
  # 
  # Using this information, the controller and action can be determined.
  # Authorization is based on whether the role has a permission that either
  # directly matches the path or represents a parent path (i.e. using the
  # controller/class hierarchy)
  named_scope :authorized_for, lambda {|*args|
    options = args.first || ''
    controller, action = Permission.recognize_path(options)
    controllers = "#{controller.camelize}Controller".constantize.ancestors.select {|c| c < ActionController::Base}.map(&:controller_path)
    
    {:joins => :permissions, :conditions => ['permissions.controller IN (?) AND (permissions.action IS NULL OR permissions.action = ?)', controllers, action]}
  }
  
  bootstrap(
    {:id => 1, :name => 'admin'}
  )
end
