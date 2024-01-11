class DiariesController < ApplicationController
before_action :logged_in_user, only: [:create, :destroy, :show, :index]
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
		if (@diary.nil? == true)
			@diary_form = current_user.diaries.build
		end
	end

end

def index
	if logged_in?	
		search_dates = []
		10.times do |n|
			search_dates.push(Time.now.ago("#{n}".to_i.years))
		end
		@diary0 = current_user.diaries.where(start_time:  (search_dates[0].in_time_zone.all_day)).last
		@diary1 = current_user.diaries.where(start_time:  (search_dates[1].in_time_zone.all_day)).last
		@diary2 = current_user.diaries.where(start_time:  (search_dates[2].in_time_zone.all_day)).last
		@diary3 = current_user.diaries.where(start_time:  (search_dates[3].in_time_zone.all_day)).last
		@diary4 = current_user.diaries.where(start_time:  (search_dates[4].in_time_zone.all_day)).last
		@diary5 = current_user.diaries.where(start_time:  (search_dates[5].in_time_zone.all_day)).last
		@diary6 = current_user.diaries.where(start_time:  (search_dates[6].in_time_zone.all_day)).last
		@diary7 = current_user.diaries.where(start_time:  (search_dates[7].in_time_zone.all_day)).last
		@diary8 = current_user.diaries.where(start_time:  (search_dates[8].in_time_zone.all_day)).last
		@diary9 = current_user.diaries.where(start_time:  (search_dates[9].in_time_zone.all_day)).last
		if @diary0.nil?
			@diary0 = current_user.diaries.build(start_time:Time.now, title: "本日の日記は未作成です", content: "Diaryより作成してください。")
		end

	end
end

def new
end

def create 
	diary_para = diary_params
	@diary = current_user.diaries.build(diary_para)

	# @diary.image.attach(params[:diary][:image])#list13.64
	if @diary.save
		flash[:success] = "日記保存しました"
		@title = @diary.title
		@contents = @diary.content
		@start_time = @diary.start_time
		render "diaries/show", status: :unprocessable_entity
	else
		# render "static_pages/home", status: :unprocessable_entity
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
		params.require(:diary).permit(:content, :title, :start_time)#list13.64
	end

	def correct_user #list13.55参考
		search_date=Time.now
		@diary = current_user.diaries.where(start_time:  (search_date.in_time_zone.all_day)).last
		redirect_to(root_url, status: :see_other) if @diary.nil?
	end
end

