require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
      @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user) #list10.17_log_in_asはlist9.25で作成
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                              email:"foo@invalid",
                                              password:                     "foo",
                                              password_confirmation:        "bar" } }
    assert_template "users/edit"
    assert_select "div.alert" ,text: "The form contains 3 errors."#10.1.3演習
  end

  test "successful edit" do
    log_in_as(@user)#list10.17_log_in_asはlist9.25で作成
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password:               "",
                                              password_confirmation:  "" }}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "successful edit wth friendly forwarding" do #list1.30
    get edit_user_path(@user)
    assert_equal session[:forwarding_url], edit_user_url(@user)#演習10.2.1
    log_in_as(@user)
    assert_nil session[:forwarding_url]#演習10.2.1
    assert_redirected_to edit_user_url(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:   name,
                                              email:  email,
                                              password:               "",
                                              password_confirmation:  "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
