require File.dirname(__FILE__) + '/../test_helper'

class RoleByDefaultTest < ActiveRecord::TestCase
  def setup
    @role = Role.new
  end
  
  def test_should_not_have_a_name
    assert @role.name.blank?
  end
end

class RoleTest < ActiveRecord::TestCase
  def test_should_be_valid_with_a_valid_set_of_attributes
    role = new_role
    assert role.valid?
  end
  
  def test_should_require_a_name
    role = new_role(:name => nil)
    assert !role.valid?
    assert role.errors.invalid?(:name)
  end
  
  def test_should_require_a_unique_name
    role = create_role(:name => 'admin')
    
    second_role = new_role(:name => 'admin')
    assert !second_role.valid?
    assert second_role.errors.invalid?(:name)
  end
end

class RoleAfterBeingCreatedTest < ActiveRecord::TestCase
  def setup
    @role = create_role
  end
  
  def test_should_not_have_any_assigned_permissions
    assert @role.permissions.empty?
  end
  
  def test_should_not_have_any_permissions
    assert @role.permissions.empty?
  end
  
  def test_should_not_have_any_assignments
    assert @role.assignments.empty?
  end
end

class RoleWithPermissionsTest < ActiveRecord::TestCase
  def setup
    @role = create_role
    @permission_create = create_permission(:controller => 'users', :action => 'create')
    @permission_update = create_permission(:controller => 'users', :action => 'update')
    
    create_role_permission(:role => @role, :permission => @permission_create)
    create_role_permission(:role => @role, :permission => @permission_update)
  end
  
  def test_should_have_assigned_permissions
    assert_equal [@permission_create, @permission_update], @role.assigned_permissions.map(&:permission)
  end
  
  def test_should_have_permissions
    assert_equal [@permission_create, @permission_update], @role.permissions
  end
end

class RoleWithAssignmentsTest < ActiveRecord::TestCase
  def setup
    @role = create_role
    
    @administrator = create_role_assignment(:role => @role, :assignee => create_user(:login => 'admin'))
    @developer = create_role_assignment(:role => @role, :assignee => create_user(:login => 'dev'))
  end
  
  def test_should_have_assignments
    assert_equal [@administrator, @developer], @role.assignments
  end
end

class RoleAuthorizedForScopeTest < ActiveRecord::TestCase
  def setup
    @role = create_role
    @permission_create = create_permission(:controller => 'users', :action => 'create')
    @permission_update = create_permission(:controller => 'users', :action => 'update')
    
    create_role_permission(:role => @role, :permission => @permission_create)
    create_role_permission(:role => @role, :permission => @permission_update)
  end
  
  def test_should_authorize_for_a_relative_url
    assert_equal [@role], Role.authorized_for('/users/create')
  end
  
  def test_should_not_authorize_for_a_relative_url_if_not_permissioned
    assert_equal [], Role.authorized_for('/admin/users/create')
  end
  
  def test_should_authorize_for_an_absolute_url
    assert_equal [@role], Role.authorized_for('http://localhost:3000/users/create')
  end
  
  def test_should_not_authorize_for_an_absolute_url_if_not_permissioned
    assert_equal [], Role.authorized_for('http://localhost:3000/users/edit')
  end
  
  def test_should_authorize_for_a_controller
    create_role_permission(:role => @role, :permission => create_permission(:controller => 'users'))
    assert_equal [@role], Role.authorized_for(:controller => 'users')
  end
  
  def test_should_not_authorize_for_a_controller_if_not_permissioned
    assert_equal [], Role.authorized_for(:controller => 'admin/users')
  end
  
  def test_should_authorize_for_a_controller_and_action
    assert_equal [@role], Role.authorized_for(:controller => 'users', :action => 'create')
  end
  
  def test_should_not_authorize_for_a_controller_and_action_if_not_permissioned
    assert_equal [], Role.authorized_for(:controller => 'users', :action => 'edit')
  end
  
  def test_should_authorize_for_the_entire_application
    create_role_permission(:role => @role, :permission => create_permission(:controller => 'application'))
    assert_equal [@role], Role.authorized_for(:controller => 'application')
  end
  
  def test_should_not_authorize_for_the_entire_application_if_not_permissioned
    assert_equal [], Role.authorized_for(:controller => 'application')
  end
  
  def test_should_authorize_if_permissioned_for_superclass_controller
    create_role_permission(:role => @role, :permission => create_permission(:controller => 'admin/base'))
    assert_equal [@role], Role.authorized_for('/admin/users')
  end
end
