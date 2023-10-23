require "test_helper"
#list10.49 pagination
#list10.63　削除リンクとユーザー削除に対応する統合テスト
class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    # @user = users(:michael) #list10.63
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end

  test "index as admin includeing pagination and delete links" do
    # log_in_as(@user)
    log_in_as(@admin)
    get users_path
    assert_template "users/index"
    assert_select "div.pagination"
    # assert_select "div.pagination",count: 2 #10.3.4演習回答
    # User.paginate(page: 1).each do |user|
    #   assert_select "a[href=?]", user_path(user), text: user.name
    #list10.63より下記範囲変更

    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      unless user == @admin
        assert_select "a[href=?]", user_path(user), text: "delete"
      end
    end
    assert_difference "User.count", -1 do
      delete user_path(@non_admin)
      assert_response :see_other
      assert_redirected_to users_url
    end
  end
  
  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select "a", text: "delete", count:0 
  end
end
