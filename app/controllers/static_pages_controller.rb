class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user = current_user
      @diaries = current_user.feed
    end
  end
end
