require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class AuthorizationHelperTest < ActionController::TestCase
  tests Admin::UsersController
  
  include ActionController::Base.master_helper_module
  
  def test_should_respond_to_authorized?
    assert respond_to?(:authorized?)
  end
  
  def test_should_respond_to_authorized_for?
    assert respond_to?(:authorized_for?)
  end
end

class AuthorizationHelperLoggedOutTest < ActionController::TestCase
  tests Admin::UsersController
  
  include ActionController::Base.master_helper_module
  
  attr_reader :controller, :session
  
  def setup
    @session = @controller.session = ActionController::TestSession.new
    session[:user_id] = nil
  end
  
  def test_should_not_be_authorized_for_current_page
    assert !authorized?
  end
  
  def test_should_not_be_authorized_for_custom_url
    assert !authorized_for?('admin/users/destroy')
  end
end

class AuthorizationHelperWithoutPermissionsTest < ActionController::TestCase
  tests Admin::UsersController
  
  include ActionController::Base.master_helper_module
  
  attr_reader :controller, :session
  
  def setup
    get :index
    
    @session = @controller.session = ActionController::TestSession.new
    
    @user = create_user
    session[:user_id] = @user.id
    
    create_permission(:controller => 'admin/users')
  end
  
  def test_should_not_be_authorized_for_current_page
    assert !authorized?
  end
  
  def test_should_not_be_authorized_for_custom_url
    assert !authorized_for?('/admin/users/destroy/1')
  end
  
  def teardown
    Permission.destroy_all
  end
end

class AuthorizationHelperWithPermissionsTest < ActionController::TestCase
  tests Admin::UsersController
  
  include ActionController::Base.master_helper_module
  
  attr_reader :controller, :session
  
  def setup
    get :index
    
    @session = @controller.session = ActionController::TestSession.new
    
    @user = create_user
    session[:user_id] = @user.id
    
    create_permission(:controller => 'admin/users')
    role = create_role(:name => 'developer', :permissions => ['admin/users/'])
    create_role_assignment(:role => role, :assignee => @user)
  end
  
  def test_should_be_authorized_for_current_page_if_user_has_proper_permissions
    assert authorized?
  end
  
  def test_should_be_authorized_for_custom_url_if_user_has_proper_permissions
    assert authorized_for?('/admin/users/destroy/1')
  end
  
  def teardown
    Role.destroy_all
    Permission.destroy_all
  end
end
