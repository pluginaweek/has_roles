require File.dirname(__FILE__) + '/../test_helper'

class UserAfterBeingCreatedTest < Test::Unit::TestCase
  def setup
    @user = create_user
  end
  
  def test_should_not_have_any_role_assignments
    assert @user.role_assignments.empty?
  end
  
  def test_should_not_have_any_roles
    assert @user.roles.empty?
  end
end

class UserWithoutRoleAssignmentsTest < Test::Unit::TestCase
  def setup
    @user = create_user
  end
  
  def test_should_be_authorized_if_path_is_not_permissioned
    assert @user.authorized_for?('/users/create')
  end
  
  def test_should_not_be_authorized_if_path_is_permissioned
    create_permission(:controller => 'users', :action => 'create')
    assert !@user.authorized_for?('/users/create')
  end
  
  def teardown
    Permission.destroy_all
  end
end

class UserWithRoleAssignmentsTest < Test::Unit::TestCase
  def setup
    @user = create_user
    @administrator = create_role(:name => 'administrator')
    @administrator.permissions << create_permission(:controller => 'admin/users')
    create_role_assignment(:assignee => @user, :role => @administrator)
    
    create_permission(:controller => 'users')
  end
  
  def test_should_have_roles
    assert_equal [@administrator], @user.roles
  end
  
  def test_should_be_authorized_if_path_is_not_permissioned
    assert @user.authorized_for?('')
  end
  
  def test_should_be_authorized_if_role_has_permission
    assert @user.authorized_for?('/admin/users')
  end
  
  def test_should_not_be_authorized_if_no_roles_have_permission
    assert !@user.authorized_for?('/users')
  end
  
  def teardown
    Role.destroy_all
    Permission.destroy_all
  end
end

class UserAfterBeingDestroyedTest < Test::Unit::TestCase
  def setup
    @user = create_user
    @administrator = create_role_assignment(:assignee => @user)
    @user.destroy
  end
  
  def test_should_destroy_associated_role_assignments
    assert_nil RoleAssignment.find_by_id(@administrator.id)
  end
  
  def teardown
    Role.destroy_all
  end
end
