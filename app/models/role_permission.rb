# Represents an assignment of a permission to a role.  The permissions for a
# role determine what parts of the system that role has access to.
# 
# == Examples
# 
#   RolePermission.bootstrap(
#     {:role => 'admin', :permission => 'application/'},
#     {:role => 'developer', :permission => 'comments/create'},
#     {:role => 'developer', :permission => 'admin/stats/'}
#   )
# 
# Notice that permissions are in the form of the path defined by the
# controller/action.
class RolePermission < ActiveRecord::Base
  extend EnumerateBy::Bootstrapped
  
  belongs_to :role
  belongs_to :permission
  
  validates_presence_of :role_id, :permission_id
  
  bootstrap(
    {:role => 'admin', :permission => 'application/'}
  )
end
