class CommunityshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @community = Community.find(params[:community_id])
    @community.invite(current_user)
    respond_to do |format|
      format.html { redirect_to @community }
      format.js
    end
  end

  def destroy
    @community = Community.find(params[:community_id])
    @community.dismiss(current_user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

end
