require "#{File.dirname(__FILE__)}/../test_helper"

class RoleTest < Test::Unit::TestCase
  fixtures :controllers, :permissions, :roles, :permissions_roles, :users, :role_assignments
  
  def test_should_be_valid
    assert_valid roles(:administrator)
  end
  
  def test_should_require_name
    assert_invalid roles(:administrator), :name, nil, ''
  end
  
  def test_should_require_unique_name
    assert_invalid roles(:administrator).clone, :name
  end
  
  def test_should_have_permissions_association
    assert_equal [permissions(:crud_application)], roles(:administrator).permissions
  end
  
  def test_should_have_assignments_association
    assert_equal [role_assignments(:administrator)], roles(:administrator).assignments
  end
  
  def test_should_destroy_assignments_when_destroyed
    roles(:administrator).destroy
    assert_nil RoleAssignment.find_by_role_id(1)
  end
  
  def test_should_use_name_for_strinigification
    assert_equal 'Administrator', roles(:administrator).to_s
  end
  
  def test_should_find_all_roles_authorized_for_path
    assert_equal [roles(:administrator), roles(:guest)], Role.find_all_authorized_for('/users/index')
  end
end
