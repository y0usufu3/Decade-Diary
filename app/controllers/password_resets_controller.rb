class PasswordResetsController < ApplicationController
  # list12.15 add two before_actions 
  before_action :get_user,          only: [:edit, :update]
  before_action :valid_user,        only: [:edit, :update]
  # list12.16 Add check_expirration
  before_action :check_expirration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to  root_url
    else
      flash.now[:danger] = "Email address not found"
      render "new", status: :unprocessable_entity
    end
  end

  def edit
  end

  #list12.16
  def  update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render "edit", status: :unprocessable_entity
    elsif @user.update(user_params)
      reset_session
      log_in @user
      @user.update_attribute(:reset_digest, nil) #list12.23 演習12.3.3　パスワード再設定が成功したダイジェストにnilへ
      flash[:success] = "Password has been reset"
      redirect_to @user
    else
      render "edit", status: :unprocessable_entity
    end
  end

  # list12.15 Add get_user,valid_user
  private
    # list12.16
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    def get_user
      @user = User.find_by(email: params[:email])
    end

    #正しいユーザーかどうか確認する
    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    #　トークンが期限切れかどうか確認するlist12.16
    def check_expirration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
