ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  #テストユーザーがログイン中の場合にtrueを返す8.2.7章
  def is_logged_in?
    !session[:user_id].nil?
  end

  # テストユーザーとしてログインする list9.25
  def log_in_as(user)
    session[:user_id] = user_id
  end
end
# list9.25
class ActionDispatch::IntegrationTest
  #テストユーザーとしてログインする list9.25
  def log_in_as(user, password: "password", remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me} }
  end
end
