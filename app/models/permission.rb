# A permission is a single collection of actions, controllers, and views that
# allow a user to gain access to a feature in the application.
class Permission < ActiveRecord::Base
  belongs_to              :controller
  has_and_belongs_to_many :roles
  
  validates_presence_of   :controller_id
  validates_length_of     :action,
                            :minimum => 1,
                            :if => :action?
  validates_uniqueness_of :action,
                            :scope => :controller_id
  
  class << self
    # Is there a permission that exists which restricts the given url?
    def restricts?(options = '')
      controller_path, action = Controller.recognize_path(options)
      !Permission.find(:first, :include => :controller, :conditions => ['path = ? AND (action IS NULL OR action = ?)', controller_path, action]).nil?
    end
    
    # Finds all roles that are authorized for the given url
    def authorized_for(options = '')
      controller_path, action = Controller.recognize_path(options)
      controller = Controller.new(:path => controller_path)
      
      find(:all,
        :include => :controller,
        :conditions => ['path IN (?) AND (action IS NULL OR action = ?)', controller.possible_path_matches, action]
      )
    end
  end
end