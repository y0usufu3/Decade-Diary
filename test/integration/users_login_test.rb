require "test_helper"

class UsersLogin < ActionDispatch::IntegrationTest

  def setup 
    @user = users(:michael)
  end
end

class InvalidPasswordTest < UsersLogin

  test "login path" do
    get login_path
    assert_template 'sessions/new'
  end

  test  "login with valid email/invalid password" do
    post login_path, params: { session: { email: @user.email, password: "invalid" } }
    assert_not is_logged_in?
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
#8.4 リファクタリングで削除された内容
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
## ここまで

end

class ValidLogin < UsersLogin
  def setup
    super
    post login_path, params: { session: { email:  @user.email,
      password: "password" } }
  end
end

class ValidLoginTest < ValidLogin

  test "valid login" do
    assert is_logged_in?
    assert_redirected_to @user
  end

  test "login with valid information" do
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
end

class Logout < ValidLogin

  def setup
    super
    delete logout_path
  end
end

class LogoutTest < Logout

  test "successful logout" do
    assert_not is_logged_in?
    assert_response :see_other
    assert_redirected_to root_path
  end

  test "redirect after logout" do
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,           count: 0
    assert_select "a[href=?]", user_path(@user),  count: 0
  end
  test "should still work after logout in second window" do #list9.15
    delete logout_path
    assert_redirected_to root_url;
  end
end
class RememberingTest < UsersLogin

  test "login with remembering" do  # list9.26
    log_in_as(@user, remember_me: "1")
    # assert_not cookies[:remember_token].blank? list9.30で削除
    assert_equal cookies[:remember_token],assigns(:user).remember_token#list9.30追加

  end

  test "login without remembering" do #list9.26
    # Cookieを保存してログイン
    log_in_as(@user, remember_me: '1')
    # Cookieを削除されていることを検証してからログイン
    log_in_as(@user, remember_me: "1")
    log_in_as(@user, remember_me: "0")
    assert cookies[:remember_token];blank?
  end
end
