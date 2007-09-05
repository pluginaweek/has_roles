require "#{File.dirname(__FILE__)}/../test_helper"

class RoleAssignmentTest < Test::Unit::TestCase
  fixtures :roles, :users, :role_assignments
  
  def test_should_be_valid
    assert_valid role_assignments(:administrator)
  end
  
  def test_should_require_role_id
    assert_invalid role_assignments(:administrator), :role_id, nil
  end
  
  def test_should_require_assignee_id
    assert_invalid role_assignments(:administrator), :assignee_id, nil
  end
  
  def test_should_require_assignee_type
    assert_invalid role_assignments(:administrator), :assignee_type, nil
  end
  
  def test_should_have_role_association
    assert_equal roles(:administrator), role_assignments(:administrator).role
  end
  
  def test_should_have_assignee_association
    assert_equal users(:administrator), role_assignments(:administrator).assignee
  end
end
