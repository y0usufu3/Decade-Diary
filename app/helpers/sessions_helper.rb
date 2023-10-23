module SessionsHelper

	#渡されたユーザーでログインする
	def log_in(user)
		session[:user_id] = user.id
		# セッションリプレイ攻撃から保護する #list 9.3 演習
		# 詳しくは https://techracho.bpsinc.jp/hachi8833/2023_06_02/130443 を参照
		session[:session_token] = user.session_token
		
	end

	#永続的セッションのためにユーザーをデータベースに記憶する
	def remember(user)
		user.remember
		cookies.permanent.encrypted[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	# 現在ログイン中のユーザーを返す（いる場合）
	def current_user
		if (user_id = session[:user_id])
			# 記憶トークンのclldieに対応するユーザを返す list9.38 演習＿コメント化と追加
			user = User.find_by(id: user_id)
			if user && session[:session_token] == user.session_token
				@current_user = user
			end
			# @current_user ||= User.find_by(id: user_id) list9.38　演習で削除
			# 以下の値の短縮形
			# if @current_user.nil?
			# 	@current_user = User.find_by(id: session[:user_id])
			# else
			# 	@current_user
			# end
		elsif (user_id = cookies.encrypted[:user_id])
			# raise #テストがパスすればこの部分テストされていないことがわかる list９．３１、list9/35で例外発生を削除
			user = User.find_by(id: user_id)
			if user && user.authenticated?(cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end
	end

	# 渡されたユーザーがカレントユーザーであればtrueを返す #10.27
	def current_user?(user)
		user && user == current_user
	end

	#ユーザーがログインしていればtrue,その他ならfalseを返す
	def logged_in?
		!current_user.nil?
	end

	#永続的セッションを破棄する
	def forget(user)
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	#現在のユーザーをログアウトする:list9.12
	def log_out
		forget(current_user)
		reset_session
		@current_user = nil #安全のため
	end

	# アクセスしようとしたURLを保存する #list10.31
	def store_location
		session[:forwarding_url] = request.original_url if request.get?
	end
end
