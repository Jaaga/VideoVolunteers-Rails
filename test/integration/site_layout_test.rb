require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    post new_user_session_path, user: { email: 'test@example.com',
                                        password: 'password',
                                        confirmed_at: Time.now,
                                        approved: true }
  end

  test "layout links" do
    get home_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", home_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", "http://videovolunteers.org/"
  end
end
