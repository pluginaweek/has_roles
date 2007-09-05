require 'has_roles/authorization_helper'

module PluginAWeek #:nodoc:
  module Has #:nodoc:
    # Provides dead simple role management
    module Roles
      def self.included(base) #:nodoc:
        base.extend(MacroMethods)
      end
      
      module MacroMethods
        # Indicates that the model has roles
        def has_roles
          has_many  :role_assignments,
                      :class_name => 'RoleAssignment',
                      :as => :assignee,
                      :dependent => :destroy
          has_many  :roles,
                      :through => :role_assignments
          
          include PluginAWeek::Has::Roles::InstanceMethods
        end
      end
      
      module InstanceMethods
        # Checks whether this user is authorized to access the given url.
        # Caching of authorizations is baked into the method.  So long as the
        # same user object is used, an authorization for the same path will be
        # cached and returned.
        # 
        # See +Controller#recognize_path+ for more information about the possible
        # +options+ that can be used.
        def authorized_for?(options = '')
          @authorizations ||= {}
          
          controller_path, action = Controller.recognize_path(options)
          options = {:controller => controller_path, :action => action}
          @authorizations["#{controller_path}/#{action}"] ||= Permission.restricts?(options) ? roles.find_all_authorized_for(options).any? : true
        end
        
        # Gets the ids of all roles associated with this user
        def role_ids
          roles.map(&:id)
        end
        
        # Sets the topics to associate with this fact.
        def role_ids=(ids)
          removed_ids = role_ids - ids
          new_ids = ids - role_ids
          
          transaction do
            role_assignments.delete(role_assignments.select {|assignment| removed_ids.include?(assignment.role_id)})
            new_ids.each {|id| role_assignments.create!(:role_id => id)}
          end
          
          roles.reload
        end
      end
    end
  end
end

ActiveRecord::Base.class_eval do
  include PluginAWeek::Has::Roles
end
