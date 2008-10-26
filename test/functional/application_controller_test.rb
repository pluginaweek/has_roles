require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ControllerLoggedOutTest < ActionController::TestCase
  tests Admin::UsersController
  
  attr_reader :session
  
  def setup
    @request.session[:user_id] = nil
    
    post :destroy, :id => 1
  end
  
  def test_should_not_be_successful
    assert_equal '401', @response.code
  end
end

class ControllerLoggedInTest < ActionController::TestCase
  tests Admin::UsersController
  
  attr_reader :session
  
  def setup
    @user = create_user
    @request.session[:user_id] = @user.id
    
    @permission = create_permission(:controller => 'admin/users')
    @role = create_role(:name => 'developer', :permissions => ['admin/users/'])
  end
  
  def test_should_be_successful_if_authorized
    create_role_assignment(:role => @role, :assignee => @user)
    
    post :destroy, :id => 1
    
    assert_response :success
  end
  
  def test_should_not_be_successful_if_unauthorized
    post :destroy, :id => 1
    
    assert_equal '401', @response.code
  end
  
  def teardown
    Role.destroy_all
    Permission.destroy_all
  end
end
