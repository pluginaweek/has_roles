require "#{File.dirname(__FILE__)}/../test_helper"

class PermissionTest < Test::Unit::TestCase
  fixtures :controllers, :permissions, :roles, :permissions_roles
  
  def test_should_be_valid
    assert_valid permissions(:crud_application)
  end
  
  def test_should_require_controller_id
    assert_invalid permissions(:crud_application), :controller_id, nil
  end
  
  def test_should_require_unique_action_per_controller
    assert_invalid permissions(:read_application).clone, :action
  end
  
  def test_should_not_require_action
    assert_valid permissions(:crud_application), :action, nil, 'show', 'update'
  end
  
  def test_should_require_specific_action_length_if_action_specified
    assert_invalid permissions(:crud_application), :action, ''
  end
  
  def test_should_have_controller_association
    assert_equal controllers(:application), permissions(:crud_application).controller
  end
  
  def test_should_have_roles_association
    assert_equal [roles(:administrator)], permissions(:crud_application).roles
  end
  
  def test_should_restrict_path_if_permissioned_action_exists
    assert Permission.restricts?('/users/index')
  end
  
  def test_should_restrict_path_if_permissioned_controller_exists
    assert Permission.restricts?('/admin/users')
  end
  
  def test_should_not_restrict_path_if_permissioned_action_doesnt_exist
    assert !Permission.restricts?(:controller => 'home', :action => 'index')
  end
  
  def test_should_not_restrict_path_if_permissioned_controller_doesnt_exist
    assert !Permission.restricts?(:controller => 'home')
  end
  
  def test_should_find_all_permissions_authorized_for_path
    assert_equal [permissions(:crud_application), permissions(:read_application), permissions(:read_users)], Permission.find_all_authorized_for('/users/index')
  end
end
