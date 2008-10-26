require File.dirname(__FILE__) + '/../test_helper'

class RoleAssignmentByDefaultTest < Test::Unit::TestCase
  def setup
    @role_assignment = RoleAssignment.new
  end
  
  def test_should_not_have_a_role
    assert_nil @role_assignment.role_id
  end
  
  def test_should_not_have_an_assignee
    assert_nil @role_assignment.assignee_id
  end
  
  def test_should_not_have_an_assignee_type
    assert @role_assignment.assignee_type.blank?
  end
end

class RoleAssignmentTest < Test::Unit::TestCase
  def test_should_be_valid_with_a_valid_set_of_attributes
    role_assignment = new_role_assignment
    assert role_assignment.valid?
  end
  
  def test_should_require_a_role
    role_assignment = new_role_assignment(:role => nil)
    assert !role_assignment.valid?
    assert_equal 1, Array(role_assignment.errors.on(:role_id)).size
  end
  
  def test_should_require_an_assignee_id
    role_assignment = new_role_assignment(:assignee => nil)
    assert !role_assignment.valid?
    assert_equal 1, Array(role_assignment.errors.on(:assignee_id)).size
  end
  
  def test_should_require_an_assignee_type
    role_assignment = new_role_assignment(:assignee => nil)
    assert !role_assignment.valid?
    assert_equal 1, Array(role_assignment.errors.on(:assignee_type)).size
  end
  
  def test_should_protect_attributes_from_mass_assignment
    create_role(:name => 'admin')
    
    role_assignment = RoleAssignment.new(
      :id => 123,
      :assignee_id => 1,
      :assignee_type => 'User',
      :role => 'admin'
    )
    
    assert_nil role_assignment.id
    assert_nil role_assignment.assignee_id
    assert_nil role_assignment.assignee_type
    assert_equal 'admin', role_assignment.role
  end
  
  def teardown
    Role.destroy_all
  end
end
