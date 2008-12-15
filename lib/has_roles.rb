require 'has_roles/authorization_helper'
require 'has_roles/url_helper'

# Adds a generic implementation for dealing with role management
module HasRoles
  module MacroMethods
    # Indicates that the model has roles. This will create the folliwng
    # association:
    # * +role_assignments+ - The join association for roles that have been assigned to a record in this model
    def has_roles
      has_many  :role_assignments,
                  :class_name => 'RoleAssignment',
                  :as => :assignee,
                  :dependent => :destroy
      
      include HasRoles::InstanceMethods
    end
  end
  
  module InstanceMethods
    # Checks whether this user is authorized to access the given url.
    # 
    # == Examples
    # 
    #   user = User.find(1)
    #   user.authorized_for?(:controller => 'admin/messages')
    #   user.authorized_for?(:controller => 'admin/messages', :action => 'destroy')
    #   user.authorized_for?('admin/messages')
    #   user.authorized_for?('http://localhost:3000/admin/messages')
    def authorized_for?(options = '')
      !Permission.restricts?(options) || roles.any? {|role| role.authorized_for?(options)}
    end
    
    # All of the roles currently assigned
    def roles
      role_assignments.map(&:role)
    end
  end
end

ActiveRecord::Base.class_eval do
  extend HasRoles::MacroMethods
end
