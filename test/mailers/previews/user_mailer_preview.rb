# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    # UserMailer.account_activation list11.18 コメント化、3行追加
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

# Preview this email at list12.10
  # http://localhost:3000/rails/mailers/user_miler/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end
end
