require File.dirname(__FILE__) + '/../test_helper'

class UrlHelperUnauthorizedTest < ActionView::TestCase
  tests HasRoles::UrlHelper
  
  def test_should_link_to_nothing_if_not_showing_text
    assert_equal '', link_to_if_authorized('Destroy User', '/admin/users/destroy', :show_text => false)
  end
  
  def test_should_display_text_if_showing_text
    assert_equal 'Destroy User', link_to_if_authorized('Destroy User', '/admin/users/destroy', :show_text => true)
  end
  
  private
    def authorized_for?(url)
      false
    end
end

class UrlHelperAuthorizedTest < ActionView::TestCase
  tests HasRoles::UrlHelper
  
  def setup
    @controller = ActionView::TestCase::TestController.new
  end
  
  def test_should_link_to_url
    assert_equal '<a href="/admin/users/destroy">Destroy User</a>', link_to_if_authorized('Destroy User', '/admin/users/destroy', :show_text => false)
  end
  
  private
    def authorized_for?(url)
      true
    end
end
