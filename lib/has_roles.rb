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
                      :as => :assignee
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
        def authorized_for?(options = '')
          @authorizations ||= {}
          
          controller_path, action = Controller.recognize_path(options)
          options = {:controller => controller_path, :action => action}
          @authorizations["#{controller_path}/#{action}"] ||= Permission.restricts?(options) ? roles.find_all_authorized_for(options).any? : true
        end
      end
    end
  end
end

ActiveRecord::Base.class_eval do
  include PluginAWeek::Has::Roles
end
