# list11.31追加
class AccountActivationsController < ApplicationController

	def edit
		user = User.find_by(email: params[:email])
		if user && !user.activated? && user.authenticated?(:activation, params[:id])
			user.activate #11.38 メソッド化　models/user.rb
			log_in user
			flash[:success]
			redirect_to user
		else
			flash[:danger] = "Invalid activation link"
			redirect_to root_url
		end
	end
end