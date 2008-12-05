require File.dirname(__FILE__) + '/../test_helper'

class RoleByDefaultTest < Test::Unit::TestCase
  def setup
    @role = Role.new
  end
  
  def test_should_not_have_a_name
    assert @role.name.blank?
  end
  
  def test_should_not_have_any_permissions
    assert @role.permissions.empty?
  end
end

class RoleTest < Test::Unit::TestCase
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
  
  def test_should_protect_attributes_from_mass_assignment
    role = Role.new(
      :id => 123,
      :name => 'developer',
      :permissions => ['application/']
    )
    
    assert_equal 123, role.id
    assert_equal 'developer', role.name
    assert_equal ['application/'], role.permissions
  end
  
  def teardown
    Role.destroy_all
  end
end

class RoleAfterBeingCreatedTest < Test::Unit::TestCase
  def setup
    @role = create_role
  end
  
  def test_should_not_have_any_assignments
    assert @role.assignments.empty?
  end
  
  def teardown
    Role.destroy_all
  end
end

class RoleWithPermissionsTest < Test::Unit::TestCase
  def setup
    @role = new_role
    @permission_create = create_permission(:id => 1, :controller => 'users', :action => 'create')
    @permission_update = create_permission(:id => 2, :controller => 'users', :action => 'update')
    
    @role.permissions.concat([@permission_create, @permission_update])
    @role.save!
  end
  
  def test_should_have_permissions
    assert_equal [@permission_create, @permission_update], @role.permissions
  end
  
  def test_should_authorize_for_a_relative_url
    assert @role.authorized_for?('/users/create')
  end
  
  def test_should_not_authorize_for_a_relative_url_if_not_permissioned
    assert !@role.authorized_for?('/admin/users/create')
  end
  
  def test_should_authorize_for_an_absolute_url
    assert @role.authorized_for?('http://localhost:3000/users/create')
  end
  
  def test_should_not_authorize_for_an_absolute_url_if_not_permissioned
    assert !@role.authorized_for?('http://localhost:3000/users/edit')
  end
  
  def test_should_authorize_for_a_controller
    @role.permissions << create_permission(:id => 3, :controller => 'users')
    assert @role.authorized_for?(:controller => 'users')
  end
  
  def test_should_not_authorize_for_a_controller_if_not_permissioned
    assert !@role.authorized_for?(:controller => 'admin/users')
  end
  
  def test_should_authorize_for_a_controller_and_action
    assert @role.authorized_for?(:controller => 'users', :action => 'create')
  end
  
  def test_should_not_authorize_for_a_controller_and_action_if_not_permissioned
    assert !@role.authorized_for?(:controller => 'users', :action => 'edit')
  end
  
  def test_should_authorize_for_the_entire_application
    @role.permissions << create_permission(:id => 3, :controller => 'application')
    assert @role.authorized_for?(:controller => 'application')
  end
  
  def test_should_not_authorize_for_the_entire_application_if_not_permissioned
    assert !@role.authorized_for?(:controller => 'application')
  end
  
  def test_should_authorize_if_permissioned_for_superclass_controller
    @role.permissions << create_permission(:id => 3, :controller => 'admin/base')
    assert @role.authorized_for?('/admin/users')
  end
  
  def teardown
    Role.destroy_all
    Permission.destroy_all
  end
end

class RoleWithAssignmentsTest < Test::Unit::TestCase
  def setup
    @role = create_role
    
    @administrator = create_role_assignment(:role => @role, :assignee => create_user(:login => 'admin'))
    @developer = create_role_assignment(:role => @role, :assignee => create_user(:login => 'dev'))
  end
  
  def test_should_have_assignments
    assert_equal [@administrator, @developer], @role.assignments
  end
  
  def teardown
    Role.destroy_all
  end
end
