class UsersController < ApplicationController
  before_action :logged_in_user,  only: [:index, :edit, :update, :destroy, :following, :followers]#list10.15,10.36,10.59,14.25:follwing,followers
  before_action :correct_user,    only: [:edit, :update]#list10.25
  before_action :admin_user,      only: :destroy #liset10.60
  
  # list10.59
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_url, status: :see_other
  end
  # list10.37
  def index
    @users = User.where(activated: true).paginate(page: params[:page])#list10.47で下記に更新
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    search_date=Time.now
    @diary = @user.diaries.where(start_time:  (search_date.in_time_zone.all_day)).last
    #...(Time.now.midnight + 1.day)).last
    if (@diary.nil? == false)
      @title = @diary.title
      @contents = @diary.content
      @start_time = @diary.start_time
    end



    #redirect_to root_url and return unless @user.activated? #list13.24で廃止
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # UserMailer.account_activation(@user).deliver_now #list11.23
      @user.send_activation_email #list11.37メソッドに置き換え
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      # reset_session
      # log_in @user
      # flash[:success] = "登録完了しました。ようこそSample App!"
      # redirect_to @user
      #下記と同等　
      # redirect_to user_url(@user)
    else 
      render "new", status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "更新完了しました"
      redirect_to @user
    # 更新に成功した場合を扱う
    else
      render "edit", status: :unprocessable_entity
    end
  end

  # list14.25
  def following
    @title = "Following"
    @user= User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end
  # list14.25
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :pssword_confirmation)
    end

    #ログイン済みユーザーかどうか確認 list10.15 liset13.34削除　application_controllerへee
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url, status: :see_other
      end
    end

    # 正しいユーザーかどうか確認 list10.25
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end
    # 管理者かどうか確認_liset10.60
    def admin_user
      redirect_to(root_url, status: :see_other) unless current_user.admin?
    end
end
