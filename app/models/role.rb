# A role defines a group of users in the system who are able to access a
# collection of features in the application.  Examples of roles could be
# 'Administrator', 'Developer', or 'Guest'.
class Role < ActiveRecord::Base
  has_and_belongs_to_many :permissions
  has_many                :assignments,
                            :class_name => 'RoleAssignment',
                            :dependent => true
  
  validates_presence_of   :name
  validates_uniqueness_of :name,
                            :allow_nil => true
  
  class << self
    # Finds all roles that are authorized for the given url
    def find_all_authorized_for(options = '')
      controller_path, action = Controller.recognize_path(options)
      controller = Controller.new(:path => controller_path)
      
      find(:all,
        :include => {:permissions => :controller},
        :conditions => ['path IN (?) AND (action IS NULL OR action = ?)', controller.possible_path_matches, action]
      )
    end
  end
  
  def to_s #:nodoc
    name
  end
end
