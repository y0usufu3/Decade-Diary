require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  
  test "account_activation" do
    #list11.20 テスト内容変更
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["opamps4@gmail.com"], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI.escape(user.email),   mail.body.encoded
    assert_match "Hi", mail.body.encoded
  end
end
