class MicropostsController < ApplicationController
	# list13.35 Micopostの各アクション認可を追加
	before_action :logged_in_user, only: [:create, :destroy]
	before_action :corrent_user,	only: :destroy #list13.55

	def create #list13.37追加
		@micropost = current_user.microposts.build(micropost_params)
		@micropost.image.attach(params[:micropost][:image])#list13.64
		if @micropost.save
			flash[:success] = "Micropost created!"
			redirect_to root_url
		else
			@feed_items = current_user.feed.paginate(page: params[:page])#13.51
			render "static_pages/home", status: :unprocessable_entity
		end
	end

	def destroy #list13.56
		@micropost.destroy
		flash[:success] = "Micropost deleted"
		if request.referrer.nil?
			redirect_to root_url, status: :see_other
		else
			redirect_to request.referrer, status: :see_other
		end
	end

	def edit
		micropost_id = params[:id]
		micoropost = Micropost.find_by(id:micropost_id)
		@updated_at = micoropost.updated_at
		@content = micoropost.content
		@user_id = micoropost.user_id
		@user = User.find_by(id:@user_id)
		@title = "#{@user.name}さんのポストからの引用"
		@diary = current_user.diaries.build(start_time:@updated_at, title: @title, content: @content)
	
		render "diary/_diary_form", status: :unprocessable_entity
		
	end

	private

		def micropost_params #list13.37
			params.require(:micropost).permit(:content, :image)#list13.64
		end

		def corrent_user #list13.55
			@micropost = current_user.microposts.find_by(id: params[:id])
			redirect_to(root_url, status: :see_other) if @micropost.nil?
		end
end
