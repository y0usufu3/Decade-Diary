# 演習11.3演習３正解化あまり自信ない
require "test_helper"

class UsersShowTest < ActionDispatch::IntegrationTest

  def setup
    @inactive_user  = users(:inactive)
    @activated_user = users(:archer)
  end
  #redirect_to root_url and return unless @user.activated? #list13.24で廃止より
  # test "should redirect when user not activated" do
  #   get user_path(@inactive_user)
  #   assert_response :success
  #   assert_redirected_to root_url
  # end

  test "should display user when activated" do
    get user_path(@activated_user)
    assert_response :ok
    assert_template "users/show"
  end
end
