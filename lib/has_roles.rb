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
          Permission.restricts?(options) ? roles.authorized_for(options).any? : true
        end
      end
    end
  end
end

ActiveRecord::Base.class_eval do
  include PluginAWeek::Has::Roles
end