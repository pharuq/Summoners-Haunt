class StaticPagesController < ApplicationController
  skip_before_action :logged_in_user

  def home
    if logged_in?
      @user = current_user
      # フィードの最大件数、'total_entries: MAX_LIMIT_FEED'がうまく動作しない
      @diaries = current_user.feed.includes(:user).paginate(page: params[:diaries],
                                      :per_page => MAX_SHOW_FEED)
      @feed_community_comments = @user.feed_topics.includes(:community, :community_topic, :user)
                                                      .paginate(page: params[:feed_community_comments],
                                      :per_page => MAX_SHOW_FEED)
      @rss = Array.new(getRSS)
    end
  end

  def about
  end

  private
    def getRSS
      tmp_rss = []
      rss = RSS::Parser.parse(RSS_URLS)
      rss.channel.items.each_with_index do|item,count|
        break if count == MAX_SHOW_RSS
        tmp_rss.push(title: item.title,
                                url: item.link)
      end
      tmp_rss
    end

end
