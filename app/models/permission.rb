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
end