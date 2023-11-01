require "test_helper"
#list11.42でテストのリファクタリング実施＿クラスを分割
class UsersIndex < ActionDispatch::IntegrationTest

#list10.49 pagination
#list10.63　削除リンクとユーザー削除に対応する統合テスト
  def setup
    # @user = users(:michael) #list10.63
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end
end

class UsersIndexAdmin < UsersIndex
  def setup
    super
    log_in_as(@admin)
    get users_path
  end
end

class UsersIndexAdminTest < UsersIndexAdmin

  test "should render the index page" do
    assert_template "users/index"
  end

  test "should paginate users" do 
    assert_select "div.pagination"
    # assert_select "div.pagination",count: 2 #10.3.4演習回答
    # User.paginate(page: 1).each do |user|
    #   assert_select "a[href=?]", user_path(user), text: user.name
    #list10.63より下記範囲変更
  end
  test "should have delete links" do
    first_page_of_users = User.where(activated: true).paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      unless user == @admin
        assert_select "a[href=?]", user_path(user), text: "delete"
      end
    end
  end

  test "should be able to delete non-admin user" do
    assert_difference "User.count", -1 do
      delete user_path(@non_admin)
    end
    assert_response :see_other
    assert_redirected_to users_url
  end

#TOGGLENがわからんｄ
  test "should displey only activated users" do #11.3.3演習３の課題のメイン
    #ページにいる最初のユーザーを無効化する。
    #無効なユーザーを作成するだけでは、
    #RAILSで際ののページが保証されないので不順分
    User.paginate(page: 1).first.toggle!(:activated)
    # /usersを再度取得して、無効化済みのユーザーが表示されていることを確かめる
    get users_path
    #表示されている全てのユーザーが有効化済みであることを確かめる
    assigns(:users).each do |user|
      assert user.activated?
    end
  end
end

class UsersNonAdminIndexTest < UsersIndex

  test "should not have delete links as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select "a", text: "delete", count:0 
  end
end
