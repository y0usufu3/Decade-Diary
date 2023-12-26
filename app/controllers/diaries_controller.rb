class DiariesController < ApplicationController
before_action :logged_in_user, only: [:create, :destroy, :show]
before_action :correct_user,	only: :destroy 

def show
	if logged_in?
		search_date=Time.now
		@diary = current_user.diaries.where(start_time:  (search_date.in_time_zone.all_day)).last
		#...(Time.now.midnight + 1.day)).last
		if (@diary.nil? == false)
			@title = @diary.title
			@contents = @diary.content
			@start_time = @diary.start_time
		end
	end

end

def index
end

def new
end

def create 
	diary_para = diary_params
	diary_day = diary_para[:start_time]
	diary_day = diary_day.midnight
	diary_para[:start_time]= diary_day
	@diary = current_user.diaries.build(diary_para)

	@diary.image.attach(params[:diary][:image])#list13.64
	if @diary.save
		flash[:success] = "日記保存しました"
		# redirect_to root_url
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

	def correct_user #list13.55参考
		search_date=Time.now
		@diary = current_user.diaries.where(start_time:  (search_date.in_time_zone.all_day)).last
		redirect_to(root_url, status: :see_other) if @diary.nil?
	end
end

