class FriendshipsController < ApplicationController

  def create
    @user = User.find(params[:to_user_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def update
    @user = User.find(params[:to_user_id])
    Friendship.find(params[:id]).update_attribute(:activated, true)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = User.find(params[:to_user_id])
    Friendship.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

end
