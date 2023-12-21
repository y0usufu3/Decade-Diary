class DiariesController < ApplicationController
# list13.35 Micopostの各アクション認可を追加
before_action :logged_in_user, only: [:create, :destroy]
before_action :corrent_user,	only: :destroy #list13.55

def create #list13.37追加
	@diary = current_user.diaries.build(diary_params)
	@diary.image.attach(params[:diary][:image])#list13.64
	if @diary.save
		flash[:success] = "日記保存しました"
		redirect_to root_url
	else
		render "static_pages/home", status: :unprocessable_entity
	end
end

def destroy #list13.56
	@diary.destroy
	flash[:success] = "日記を削除しました"
	if request.referrer.nil?
		redirect_to root_url, status: :see_other
	else
		redirect_to request.referrer, status: :see_other
	end
end

private

	def diary_params #list13.37参考
		params.require(:diary).permit(:content, :title, :image, :start_time)#list13.64
	end

	def corrent_user #list13.55参考
		@diary = current_user.diaries.find_by(id: params[:id])
		redirect_to(root_url, status: :see_other) if @diary.nil?
	end
end

