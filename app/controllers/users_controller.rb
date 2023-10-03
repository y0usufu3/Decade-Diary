class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "登録完了しました。ようこそSample App!"
      redirect_to @user
      #下記と同等　
      # redirect_to user_url(@user)
    else 
      render "new", status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :pssword_confirmation)
    end
end
