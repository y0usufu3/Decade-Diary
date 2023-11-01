class SessionsController < ApplicationController
  def new
    
  end

  def create #list9.29 インスタンス変数
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])#演習8.2.6の２よりぼっち演算子へ変更　obj && obj.method == obj&.method
      if user.activated? #list11.32 有効化していないユーザーはログインできない
        forwarding_url = session[:forwarding_url] #list10.33
        reset_session
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)#9.24　三項演算子
      # if params[:sesion][:remember_me] == "1" #上記の三項演算子の展開版
      #   remember(user)
      # else
      #   forget(user)
      # end
        log_in user
        redirect_to forwarding_url || user # list10.33
      # ユーザーログイン後にユーザー情報にリダイレクトする
      else
        message = "Account not activated."
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end

    else
      flash.now[:danger] = "Invalid email/password combination"
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?#list9.17
    redirect_to root_url, status: :see_other
  end
end
