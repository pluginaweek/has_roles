require "#{File.dirname(__FILE__)}/../test_helper"

class HasRolesTest < Test::Unit::TestCase
  fixtures :controllers, :permissions, :roles, :permissions_roles, :users, :role_assignments
  
  def test_should_have_role_assignments_association
    assert_equal [role_assignments(:administrator)], users(:administrator).role_assignments
  end
  
  def test_should_destroy_role_assignments_when_destroyed
    users(:administrator).destroy
    assert_nil RoleAssignment.find_by_assignee_id(1)
  end
  
  def test_should_have_roles_association
    assert_equal [roles(:administrator)], users(:administrator).roles
  end
  
  def test_should_be_authorized_if_user_has_proper_permissions
    assert users(:guest).authorized_for?('/users/index')
  end
  
  def test_should_not_be_authorized_if_user_doesnt_have_proper_permissions
    assert !users(:guest).authorized_for?('/admin/users/destroy')
  end
  
  def test_roles_ids_should_map_all_ids
    assert_equal [1], users(:administrator).role_ids
  end
  

  def test_should_destroy_old_roles_when_replaced
    user = users(:administrator)
    user.role_ids = []
    assert_equal [], user.roles
  end
  
  def test_should_add_new_roles_when_replaced
    user = users(:administrator)
    user.role_ids = [1, 2]
    assert_equal [roles(:administrator), roles(:moderator)], user.roles
  end
  
  def test_should_destroy_old_roles_and_add_new_roles_when_replaced
    user = users(:administrator)
    user.role_ids = [2]
    assert_equal [roles(:moderator)], user.roles
  end
end
