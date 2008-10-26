require File.dirname(__FILE__) + '/../test_helper'

class PermissionByDefaultTest < Test::Unit::TestCase
  def setup
    @permission = Permission.new
  end
  
  def test_should_not_have_a_controller
    assert_nil @permission.controller
  end
  
  def test_should_not_have_an_action
    assert @permission.action.blank?
  end
  
  def test_should_have_a_path
    assert_equal '/', @permission.path
  end
  
  def test_should_use_controller_as_path_if_not_specified
    permission = Permission.new(:controller => 'users')
    assert_equal 'users/', permission.path
  end
  
  def test_should_use_controller_and_action_as_path_if_not_specified
    permission = Permission.new(:controller => 'users', :action => 'index')
    assert_equal 'users/index', permission.path
  end
end

class PermissionTest < Test::Unit::TestCase
  def test_should_be_valid_with_a_valid_set_of_attributes
    permission = new_permission
    assert permission.valid?
  end
  
  def test_should_require_an_id
    permission = new_permission(:id => nil)
    assert !permission.valid?
    assert_equal 1, Array(permission.errors.on(:id)).size
  end
  
  def test_should_require_a_controller
    permission = new_permission(:controller => nil)
    assert !permission.valid?
    assert_equal 1, Array(permission.errors.on(:controller)).size
  end
  
  def test_should_not_require_an_action
    permission = new_permission(:action => nil)
    assert permission.valid?
  end
  
  def test_should_require_at_least_1_character_if_action_is_specified
    permission = new_permission(:action => '')
    assert !permission.valid?
    assert_equal 1, Array(permission.errors.on(:action)).size
  end
  
  def test_should_require_a_path
    permission = new_permission
    permission.path = nil
    assert !permission.valid?
    assert_equal 1, Array(permission.errors.on(:path)).size
  end
  
  def test_should_require_a_unique_path
    permission = create_permission(:controller => 'application')
    
    second_permission = new_permission(:controller => 'application')
    assert !second_permission.valid?
    assert_equal 1, Array(second_permission.errors.on(:path)).size
  end
  
  def test_should_protect_attributes_from_mass_assignment
    permission = Permission.new(
      :id => 123,
      :controller => 'site',
      :action => 'about',
      :path => 'invalid'
    )
    
    assert_equal 123, permission.id
    assert_equal 'site', permission.controller
    assert_equal 'about', permission.action
    assert_equal 'site/about', permission.path
  end
  
  def teardown
    Permission.destroy_all
  end
end

class PermissionAfterBeingCreatedTest < Test::Unit::TestCase
  def setup
    @permission = create_permission(:controller => 'application')
  end
  
  def test_should_have_an_id
    assert_not_nil @permission.id
  end
  
  def teardown
    Permission.destroy_all
  end
end

class PermissionAsAClassTest < Test::Unit::TestCase
  def test_should_recognize_path_by_relative_url
    assert_equal ['users', 'index'], Permission.recognize_path('/users')
  end
  
  def test_should_recognize_path_by_relative_url_with_namespace
    assert_equal ['admin/users', 'update'], Permission.recognize_path('/admin/users/update')
  end
  
  def test_should_recognize_path_by_absolute_url
    assert_equal ['users', 'index'], Permission.recognize_path('http://localhost:3000/users')
  end
  
  def test_should_recognize_path_by_hash
    assert_equal ['users', 'index'], Permission.recognize_path(:controller => 'users', :action => 'index')
  end
  
  def test_should_recognize_path_by_hash_with_namespace
    assert_equal ['admin/users', 'update'], Permission.recognize_path(:controller => 'admin/users', :action => 'update', :id => 1)
  end
  
  def test_should_recognize_path_if_action_not_specified
    assert_equal ['users', 'index'], Permission.recognize_path(:controller => 'users')
  end
  
  def test_should_restrict_path_if_permission_exists_for_path
    create_permission(:controller => 'application')
    assert Permission.restricts?(:controller => 'application')
  end
  
  def test_should_not_restrict_path_if_no_permission_exists_for_path
    assert !Permission.restricts?('/users')
  end
  
  def teardown
    Permission.destroy_all
  end
end
