require File.dirname(__FILE__) + '/../test_helper'

class AuthorizationHelperTest < Test::Unit::TestCase
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include PluginAWeek::HasRoles::AuthorizationHelper
  
  def setup
    @user = create_user
    
    @developer = create_role(:name => 'developer')
    @developer.permissions << create_permission(:id => 1, :controller => 'users')
    create_role_assignment(:assignee => @user, :role => @developer)
    
    create_permission(:id => 2, :controller => 'admin/users')
    
    @controller = HomeController.new
    @controller.request = ActionController::TestRequest.new
    @controller.instance_eval {@_params = request.path_parameters}
    @controller.send(:initialize_current_url)
  end
  
  def current_user
    @user
  end
  
  def test_should_be_authorized_if_user_has_proper_permissions
    assert authorized_for?('/users/index')
  end
  
  def test_should_not_be_authorized_if_user_doesnt_have_proper_permissions
    assert !authorized_for?('/admin/users/destroy')
  end
  
  def test_should_link_to_nothing_if_not_authorized_and_not_showing_text
    assert_equal '', link_to_if_authorized('Destroy User', '/admin/users/destroy', :show_text => false)
  end
  
  def test_should_display_text_if_not_authorized_and_showing_text
    assert_equal 'Destroy User', link_to_if_authorized('Destroy User', '/admin/users/destroy', :show_text => true)
  end
  
  def test_should_link_to_url_if_authorized
    assert_equal '<a href="/users">Destroy User</a>', link_to_if_authorized('Destroy User', {:controller => 'users', :action => 'index'}, :show_text => false)
  end
  
  def teardown
    Role.destroy_all
    Permission.destroy_all
  end
end
