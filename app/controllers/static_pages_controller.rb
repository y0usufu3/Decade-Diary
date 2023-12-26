class StaticPagesController < ApplicationController
  def home
    if logged_in?
    @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @diary      = current_user.diaries.build
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

  def help
  end

  def about
  end

  def contact
  end

  
end

