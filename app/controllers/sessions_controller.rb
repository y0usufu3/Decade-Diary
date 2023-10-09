class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])#演習8.2.6の２よりぼっち演算子へ変更　obj && obj.method == obj&.method
      reset_session
      log_in user
      redirect_to user
      # ユーザーログイン後にユーザー情報にリダイレクトする
    else
      flash.now[:danger] = "Invalid email/password combination"
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end
end
