# Represents an assignment of a role to a user (assignee) in the system
class RoleAssignment < ActiveRecord::Base
  belongs_to :role
  belongs_to :assignee, :polymorphic => true
  
  validates_presence_of :role_id, :assignee_id, :assignee_type
  
  attr_accessible :role
end
