# A role defines a group of users in the system who are able to access a
# collection of features in the application
class Role < ActiveRecord::Base
  has_and_belongs_to_many :permissions
  
  validates_presence_of   :name
  validates_uniqueness_of :name
  validates_length_of     :name,
                            :minimum => 1
  
  def to_s #:nodoc
    name
  end
end