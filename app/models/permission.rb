# A permission defines access to a single part of an application, restricted by
# both controller and action specifications.
# 
# Permissions can be application-, controller-, or action-specific.  Permissions
# using the +application+ controller are global.  Permissions without any +action+
# specified are controller-specific.  Permissions with both +controller+ and
# +action+ specified are action-specific.
class Permission < ActiveRecord::Base
  belongs_to              :controller
  has_and_belongs_to_many :roles
  
  validates_presence_of   :controller_id
  validates_length_of     :action,
                            :minimum => 1,
                            :allow_nil => true
  validates_uniqueness_of :action,
                            :scope => :controller_id,
                            :allow_nil => true
  
  class << self
    # Is there a permission that exists which restricts the given url?.  See
    # <tt>Controller#recognize_path</tt> for possible options.
    def restricts?(options = '')
      controller_path, action = Controller.recognize_path(options)
      count(
        :include => :controller,
        :conditions => ['path = ? AND (action IS NULL OR action = ?)', controller_path, action],
        :distinct => true # TODO: Workaround for old sqlite versions until Rails 1.2
      ) > 0
    end
    
    # Finds all permissions that are authorized for the given url.  See
    # <tt>Controller#recognize_path</tt> for possible options.
    def find_all_authorized_for(options = '')
      controller_path, action = Controller.recognize_path(options)
      controller = Controller.new(:path => controller_path)
      
      find(:all,
        :include => :controller,
        :conditions => ['path IN (?) AND (action IS NULL OR action = ?)', controller.possible_path_matches, action]
      )
    end
  end
end
