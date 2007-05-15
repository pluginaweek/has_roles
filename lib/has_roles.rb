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
          has_and_belongs_to_many :roles,
                                    :foreign_key => 'user_id'
          
          include PluginAWeek::Has::Roles::InstanceMethods
        end
      end
      
      module InstanceMethods
        # Checks whether this user is authorized to access the given url
        def authorized_for?(options = '')
          options = ActionController::Routing::Routes.recognize_path(URI.parse(options).path) if options.is_a?(String)
          controller_path, action = options[:controller], options[:action].to_s
          controller_path = controller_path.controller_path if controller_path.is_a?(Class)
          
          # First, is this controller/action permissioned?
          if permission = Permission.find(:first, :include => :controller, :conditions => ['path = ? AND (action IS NULL OR action = ?)', controller_path, action])
            # Now let's find a role with a valid permission for this user
            roles.calculate(
              :count, '*',
              :include => {:permissions => :controller},
              :conditions => ['path IN (?) AND (action IS NULL OR action = ?)', permission.controller.possible_path_matches, action]
            ) > 0
          else
            # Always authorize for controller/actions that are not permissioned
            true
          end
        end
      end
    end
  end
end

ActiveRecord::Base.class_eval do
  include PluginAWeek::Has::Roles
end