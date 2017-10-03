class FriendshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:to_user_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Friendship.find(params[:id]).to_user
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

end
