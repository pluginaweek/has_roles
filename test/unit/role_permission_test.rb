require File.dirname(__FILE__) + '/../test_helper'

class RolePermissionByDefaultTest < ActiveRecord::TestCase
  def setup
    @role_permission = RolePermission.new
  end
  
  def test_should_not_have_a_role
    assert_nil @role_permission.role_id
  end
  
  def test_should_not_have_a_permission
    assert_nil @role_permission.permission_id
  end
end

class RolePermissionTest < ActiveRecord::TestCase
  def test_should_be_valid_with_a_valid_set_of_attributes
    role_permission = new_role_permission
    assert role_permission.valid?
  end
  
  def test_should_require_a_role
    role_permission = new_role_permission(:role => nil)
    assert !role_permission.valid?
    assert role_permission.errors.invalid?(:role_id)
  end
  
  def test_should_require_a_permission
    role_permission = new_role_permission(:permission => nil)
    assert !role_permission.valid?
    assert role_permission.errors.invalid?(:permission_id)
  end
end
