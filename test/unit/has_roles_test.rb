require "#{File.dirname(__FILE__)}/../test_helper"

class HasRolesTest < Test::Unit::TestCase
  fixtures :controllers, :permissions, :roles, :permissions_roles, :users, :role_assignments
  
  def test_should_have_role_assignments_association
    assert_equal [role_assignments(:administrator)], users(:administrator).role_assignments
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
end
