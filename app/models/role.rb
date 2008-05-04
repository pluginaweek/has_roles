# A role defines a group of users in the system who are able to access a
# collection of features in the application.  Examples of roles could be
# 'Administrator', 'Developer', or 'Guest'.
class Role < ActiveRecord::Base
  acts_as_enumeration
  
  attr_accessor :permissions
  
  has_many  :assignments,
              :class_name => 'RoleAssignment',
              :dependent => :destroy
  
  def initialize(attributes = nil) #:nodoc:
    super
    @authorizations ||= {}
    @permissions = []
  end
  
  # Is this role authorized for the given url?
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
    Permission['application']
  ]
end
