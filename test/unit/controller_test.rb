require "#{File.dirname(__FILE__)}/../test_helper"

class ControllerTest < Test::Unit::TestCase
  fixtures :controllers, :permissions
  
  def test_should_be_valid
    assert_valid controllers(:users)
  end
  
  def test_should_require_path
    assert_invalid controllers(:users), :path, nil, ''
  end
  
  def test_should_require_specific_format_for_paths
    assert_invalid controllers(:users), :path, '/users', '//users', 'users/', 'admin//users', '1'
  end
  
  def test_should_require_unique_path
    assert_invalid controllers(:users).clone, :path
  end
  
  def test_should_have_associated_permissions
    assert_equal [permissions(:read_users), permissions(:update_users)], controllers(:users).permissions
  end
  
  def test_should_destroy_associated_permissions_when_destroyed
    controllers(:users).destroy
    assert_nil Permission.find_by_controller_id(2)
  end
  
  def test_should_use_path_for_klass
    assert_equal UsersController, controllers(:users).klass
  end
  
  def test_should_use_namespaced_path_for_klass
    assert_equal Admin::UsersController, controllers(:admin_users).klass
  end
  
  def test_should_use_controller_name_for_name_if_controller_is_not_namespaced
    assert_equal 'Users', controllers(:users).name
  end
  
  def test_should_use_demodulized_controller_name_for_name_if_controller_is_namespaced
    assert_equal 'Users', controllers(:admin_users).name
  end
  
  def test_possible_path_matches_should_include_all_superclasses_except_base_controller
    assert_equal %w(users application), controllers(:users).possible_path_matches
    assert_equal %w(admin/users application), controllers(:admin_users).possible_path_matches
    assert_equal %w(payment/pay_pal/transactions payment/transactions application), controllers(:payment_pay_pal_transactions).possible_path_matches
  end
  
  def test_should_be_global_if_path_is_application
    assert controllers(:application).global?
  end
  
  def test_should_not_be_global_if_path_is_not_application
    assert !controllers(:users).global?
    assert !controllers(:admin_users).global?
  end
  
  def test_stringification_should_use_name
    assert_equal 'Users', controllers(:users).to_s
  end
  
  def test_should_map_parents_for_all_controllers
    expected = [
      [Object, [controllers(:application), controllers(:users)]],
      [Admin, [controllers(:admin_users)]],
      [Payment, [controllers(:payment_transactions)]],
      [Payment::PayPal, [controllers(:payment_pay_pal_transactions)]]
    ]
    assert_equal expected, Controller.find_all_mapped_by_parent
  end
  
  def test_should_recognize_path_by_string
    assert_equal ['users', 'index'], Controller.recognize_path('/users')
  end
  
  def test_should_recognize_namespaced_path_by_string
    assert_equal ['admin/users', 'update'], Controller.recognize_path('/admin/users/update')
  end
  
  def test_should_recognize_path_by_hash
    assert_equal ['users', 'index'], Controller.recognize_path(:controller => 'users', :action => 'index')
  end
  
  def test_should_recognize_namespaced_path_by_hash
    assert_equal ['admin/users', 'update'], Controller.recognize_path(:controller => 'admin/users', :action => 'update', :id => 1)
  end
  
  def test_should_recognize_path_if_action_not_specified
    assert_equal ['users', 'index'], Controller.recognize_path(:controller => 'users')
  end
end
