class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user = current_user
      # 'total_entries: MAX_LIMIT_FEED'がうまく動作しない
      @diaries = current_user.feed.paginate(page: params[:diaries],
                                      :per_page => MAX_SHOW_FEED)
      @feed_community_comments = @user.feed_topics.paginate(page: params[:feed_community_comments],
                                      :per_page => MAX_SHOW_FEED)
      @rss = Array.new(getRSS)
    end
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
