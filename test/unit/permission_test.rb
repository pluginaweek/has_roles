require File.dirname(__FILE__) + '/../test_helper'

class PermissionByDefaultTest < ActiveRecord::TestCase
  def setup
    @permission = Permission.new
  end
  
  def test_should_not_have_a_controller
    assert @permission.controller.blank?
  end
  
  def test_should_not_have_an_action
    assert @permission.action.blank?
  end
  
  def test_should_not_have_a_path
    assert @permission.path.blank?
  end
  
  def test_should_use_controller_as_path_if_not_specified
    permission = Permission.new(:controller => 'users')
    permission.valid?
    assert_equal 'users/', permission.path
  end
  
  def test_should_use_controller_and_action_as_path_if_not_specified
    permission = Permission.new(:controller => 'users', :action => 'index')
    permission.valid?
    assert_equal 'users/index', permission.path
  end
end

class PermissionTest < ActiveRecord::TestCase
  def test_should_be_valid_with_a_valid_set_of_attributes
    permission = new_permission
    assert permission.valid?
  end
  
  def test_should_require_a_controller
    permission = new_permission(:controller => nil)
    assert !permission.valid?
    assert permission.errors.invalid?(:controller)
  end
  
  def test_should_not_require_an_action
    permission = new_permission(:action => nil)
    assert permission.valid?
  end
  
  def test_should_require_at_least_1_character_if_action_is_specified
    permission = new_permission(:action => '')
    assert !permission.valid?
    assert permission.errors.invalid?(:action)
  end
  
  def test_should_require_a_unique_path
    permission = create_permission(:controller => 'application')
    
    second_permission = new_permission(:controller => 'application')
    assert !second_permission.valid?
    assert second_permission.errors.invalid?(:path)
  end
end

class PermissionAfterBeingCreatedTest < ActiveRecord::TestCase
  def setup
    @permission = create_permission(:controller => 'application')
  end
  
  def test_should_have_a_path
    assert_equal 'application/', @permission.path
  end
  
  def test_should_have_no_assigned_roles
    assert @permission.assigned_roles.empty?
  end
  
  def test_should_have_no_roles
    assert @permission.roles.empty?
  end
end

class PermissionPathRecognitionTest < ActiveRecord::TestCase
  def test_should_recognize_by_relative_url
    assert_equal ['users', 'index'], Permission.recognize_path('/users')
  end
  
  def test_should_recognize_by_relative_url_with_namespace
    assert_equal ['admin/users', 'update'], Permission.recognize_path('/admin/users/update')
  end
  
  def test_should_recognize_by_absolute_url
    assert_equal ['users', 'index'], Permission.recognize_path('http://localhost:3000/users')
  end
  
  def test_should_recognize_by_hash
    assert_equal ['users', 'index'], Permission.recognize_path(:controller => 'users', :action => 'index')
  end
  
  def test_should_recognize_by_hash_with_namespace
    assert_equal ['admin/users', 'update'], Permission.recognize_path(:controller => 'admin/users', :action => 'update', :id => 1)
  end
  
  def test_should_recognize_if_action_not_specified
    assert_equal ['users', 'index'], Permission.recognize_path(:controller => 'users')
  end
end

class PermissionRestrictionTest < ActiveRecord::TestCase
  def test_should_restrict_if_permission_exists_for_path
    create_permission(:controller => 'application')
    assert Permission.restricts?(:controller => 'application')
  end
  
  def test_should_not_restrict_if_no_permission_exists_for_path
    assert !Permission.restricts?('/users')
  end
end
